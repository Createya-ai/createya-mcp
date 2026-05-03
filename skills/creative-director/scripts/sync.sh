#!/usr/bin/env bash
# Sync local creative/assets/ → Createya S3 (ephemeral, 24h auto-delete).
#
# Compares local files with creative/.assets-index.json:
#   - new file → upload (request presigned URL → curl PUT → record cdn_url)
#   - changed file (sha256 differs) → re-upload
#   - file already uploaded with valid will_delete_at > now+1h → skip
#   - file expiring within 1h → re-upload (refresh)
#
# Usage:
#   ./scripts/sync.sh                  # sync all of creative/assets/
#   ./scripts/sync.sh models/sarah     # sync only one subfolder
#
# Requires: curl, jq, sha256sum (or shasum on macOS).

set -euo pipefail

PROJECT_ROOT="$(pwd)"
[[ -d "$PROJECT_ROOT/creative/assets" ]] || {
  echo "✗ Not a Creative Director workspace (no creative/assets/). Run ./scripts/setup.sh first."
  exit 1
}

# Load env
if [[ -f "$PROJECT_ROOT/.env" ]]; then
  set -a; source "$PROJECT_ROOT/.env"; set +a
fi
: "${CREATEYA_API_KEY:?CREATEYA_API_KEY is not set in .env}"
BASE="${CREATEYA_API_BASE:-https://api.createya.ai}"

INDEX_FILE="$PROJECT_ROOT/creative/.assets-index.json"
[[ -f "$INDEX_FILE" ]] || echo '{}' > "$INDEX_FILE"

# Cross-platform sha256
if command -v sha256sum >/dev/null 2>&1; then
  SHA256_CMD="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  SHA256_CMD="shasum -a 256"
else
  echo "✗ Need sha256sum (Linux) or shasum (macOS)"
  exit 1
fi

sha256_of() { $SHA256_CMD "$1" | cut -d' ' -f1; }

# MIME detection (rudimentary, by extension — sufficient for skill use case)
mime_of() {
  local f="$1"
  local ext="${f##*.}"
  case "${ext,,}" in
    jpg|jpeg) echo "image/jpeg" ;;
    png)      echo "image/png"  ;;
    webp)     echo "image/webp" ;;
    gif)      echo "image/gif"  ;;
    heic)     echo "image/heic" ;;
    heif)     echo "image/heif" ;;
    mp4)      echo "video/mp4"  ;;
    mov)      echo "video/quicktime" ;;
    webm)     echo "video/webm" ;;
    mp3)      echo "audio/mpeg" ;;
    wav)      echo "audio/wav"  ;;
    ogg)      echo "audio/ogg"  ;;
    m4a)      echo "audio/mp4"  ;;
    *)        echo ""           ;;
  esac
}

# When does an indexed entry need refresh?
# Refresh if expires within 1 hour (3600s).
needs_refresh() {
  local will_delete="$1"   # ISO 8601 like 2026-05-04T15:00:00.000Z
  [[ -z "$will_delete" ]] && return 0
  local now epoch_will
  now=$(date +%s)
  # macOS date doesn't accept ISO with Z directly; strip ".xxxZ" → "Z" then use BSD or GNU
  local will_clean="${will_delete%.*}Z"
  if epoch_will=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$will_clean" +%s 2>/dev/null); then
    : # macOS path
  elif epoch_will=$(date -u -d "$will_delete" +%s 2>/dev/null); then
    : # GNU path
  else
    return 0  # parse failed → safer to re-upload
  fi
  (( epoch_will - now < 3600 ))
}

# Subfolder filter
SUBFILTER="${1:-}"
ASSETS_ROOT="$PROJECT_ROOT/creative/assets"
SCAN_PATH="$ASSETS_ROOT"
[[ -n "$SUBFILTER" ]] && SCAN_PATH="$ASSETS_ROOT/$SUBFILTER"
[[ -d "$SCAN_PATH" ]] || { echo "✗ No such folder: $SCAN_PATH"; exit 1; }

uploaded=0
skipped=0
failed=0

# Find all eligible files (skip hidden, _vision.md, .DS_Store)
while IFS= read -r -d '' file; do
  rel="${file#$ASSETS_ROOT/}"
  # Skip aux files
  case "$(basename "$file")" in
    _vision.md|.DS_Store|*.tmp) skipped=$((skipped+1)); continue ;;
  esac
  case "$rel" in
    *_vision.md|.*) skipped=$((skipped+1)); continue ;;
  esac

  mime="$(mime_of "$file")"
  if [[ -z "$mime" ]]; then
    skipped=$((skipped+1))
    continue
  fi

  size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
  sha=$(sha256_of "$file")

  # Check existing entry in index
  existing="$(jq -r --arg k "$rel" '.[$k] // empty' "$INDEX_FILE")"
  if [[ -n "$existing" ]]; then
    cur_sha=$(echo "$existing" | jq -r '.sha256 // empty')
    cur_will=$(echo "$existing" | jq -r '.will_delete_at // empty')
    if [[ "$cur_sha" == "$sha" ]] && ! needs_refresh "$cur_will"; then
      skipped=$((skipped+1))
      continue
    fi
  fi

  printf "↑ %s ... " "$rel"

  # Step 1: presigned URL
  payload="$(jq -n \
    --arg filename "$(basename "$rel")" \
    --arg mime "$mime" \
    --arg folder "$(dirname "$rel")" \
    --argjson size "$size" \
    '{filename:$filename, mime_type:$mime, size_bytes:$size, folder_path:$folder}')"

  resp="$(curl -sS -X POST "$BASE/v1/uploads/presigned" \
    -H "Authorization: Bearer $CREATEYA_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$payload" || echo '{"error":"curl_failed"}')"

  presigned="$(echo "$resp" | jq -r '.presigned_url // empty')"
  cdn_url="$(echo "$resp" | jq -r '.cdn_url // empty')"
  will_delete="$(echo "$resp" | jq -r '.will_delete_at // empty')"

  if [[ -z "$presigned" || -z "$cdn_url" ]]; then
    err="$(echo "$resp" | jq -r '.error.message // .error // "unknown"')"
    echo "FAIL ($err)"
    failed=$((failed+1))
    continue
  fi

  # Step 2: PUT bytes
  put_code="$(curl -sS -o /dev/null -w "%{http_code}" \
    -X PUT -H "Content-Type: $mime" \
    --upload-file "$file" \
    "$presigned" || echo "000")"

  if [[ "$put_code" != "200" && "$put_code" != "201" ]]; then
    echo "FAIL (PUT $put_code)"
    failed=$((failed+1))
    continue
  fi

  # Step 3: update index
  jq --arg k "$rel" \
     --arg cdn "$cdn_url" \
     --arg sha "$sha" \
     --arg mime "$mime" \
     --arg will "$will_delete" \
     --argjson size "$size" \
     --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
     '.[$k] = {cdn_url:$cdn, sha256:$sha, mime_type:$mime, size_bytes:$size, uploaded_at:$now, will_delete_at:$will}' \
     "$INDEX_FILE" > "$INDEX_FILE.tmp"
  mv "$INDEX_FILE.tmp" "$INDEX_FILE"

  echo "OK"
  uploaded=$((uploaded+1))

done < <(find "$SCAN_PATH" -type f -print0)

echo ""
echo "Sync done: $uploaded uploaded, $skipped skipped, $failed failed"
[[ $failed -gt 0 ]] && exit 1 || exit 0
