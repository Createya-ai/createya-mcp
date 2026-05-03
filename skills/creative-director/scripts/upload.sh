#!/usr/bin/env bash
# Single-file upload to Createya ephemeral storage.
# Returns just the CDN URL on stdout — useful for inline use in skill.
#
# Usage:
#   ./scripts/upload.sh <local-file> [folder-hint]
#
# Example:
#   url=$(./scripts/upload.sh /tmp/photo.jpg "products/yellow-hoodie")
#   echo $url  # → https://cdn-new.createya.ai/temp/<uid>/products/yellow-hoodie/<...>.jpg
#
# Does NOT update creative/.assets-index.json — that's sync.sh's job.
# Use this for ad-hoc uploads (e.g. attached file Claude Code drag-dropped).

set -euo pipefail

FILE="${1:?Usage: $0 <local-file> [folder-hint]}"
FOLDER="${2:-}"

[[ -f "$FILE" ]] || { echo "✗ File not found: $FILE" >&2; exit 1; }

PROJECT_ROOT="$(pwd)"
[[ -f "$PROJECT_ROOT/.env" ]] && { set -a; source "$PROJECT_ROOT/.env"; set +a; }
: "${CREATEYA_API_KEY:?CREATEYA_API_KEY is not set in .env}"
BASE="${CREATEYA_API_BASE:-https://api.createya.ai}"

# Mime by extension
ext="${FILE##*.}"
case "${ext,,}" in
  jpg|jpeg) mime="image/jpeg" ;;
  png)      mime="image/png"  ;;
  webp)     mime="image/webp" ;;
  gif)      mime="image/gif"  ;;
  heic)     mime="image/heic" ;;
  heif)     mime="image/heif" ;;
  mp4)      mime="video/mp4"  ;;
  mov)      mime="video/quicktime" ;;
  webm)     mime="video/webm" ;;
  mp3)      mime="audio/mpeg" ;;
  wav)      mime="audio/wav"  ;;
  ogg)      mime="audio/ogg"  ;;
  m4a)      mime="audio/mp4"  ;;
  *)        echo "✗ Unsupported extension: $ext" >&2; exit 1 ;;
esac

size=$(stat -f%z "$FILE" 2>/dev/null || stat -c%s "$FILE")
filename="$(basename "$FILE")"

payload="$(jq -n \
  --arg filename "$filename" \
  --arg mime "$mime" \
  --arg folder "$FOLDER" \
  --argjson size "$size" \
  '{filename:$filename, mime_type:$mime, size_bytes:$size, folder_path:$folder}')"

resp="$(curl -sS -X POST "$BASE/v1/uploads/presigned" \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$payload")"

presigned="$(echo "$resp" | jq -r '.presigned_url // empty')"
cdn_url="$(echo "$resp" | jq -r '.cdn_url // empty')"

if [[ -z "$presigned" || -z "$cdn_url" ]]; then
  echo "✗ Failed to get presigned URL: $resp" >&2
  exit 1
fi

put_code="$(curl -sS -o /dev/null -w "%{http_code}" \
  -X PUT -H "Content-Type: $mime" \
  --upload-file "$FILE" \
  "$presigned")"

if [[ "$put_code" != "200" && "$put_code" != "201" ]]; then
  echo "✗ PUT failed: HTTP $put_code" >&2
  exit 1
fi

# Output ONLY the CDN URL on stdout (caller may capture it)
echo "$cdn_url"
