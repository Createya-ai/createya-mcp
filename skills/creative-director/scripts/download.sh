#!/usr/bin/env bash
# Download a generation result (or any URL) into the current session folder.
# Designed for skill: after run_model returns output.urls[0] → save locally
# so Claude can Read it for visual QA, and the user can open it.
#
# Usage:
#   ./scripts/download.sh <url> [target-path]
#
# If target-path is omitted, saves to creative/sessions/<latest>/results/<sanitized>.<ext>
#
# Examples:
#   ./scripts/download.sh https://cdn-new.createya.ai/.../result.jpg
#   ./scripts/download.sh https://... creative/sessions/2026-05-03-yellow-hoodie/results/etalon.jpg

set -euo pipefail

URL="${1:?Usage: $0 <url> [target-path]}"
TARGET="${2:-}"

PROJECT_ROOT="$(pwd)"

# If no target — auto-pick latest session
if [[ -z "$TARGET" ]]; then
  SESSIONS_DIR="$PROJECT_ROOT/creative/sessions"
  [[ -d "$SESSIONS_DIR" ]] || { echo "✗ No creative/sessions/ — run setup.sh first" >&2; exit 1; }

  latest="$(ls -1t "$SESSIONS_DIR" 2>/dev/null | head -1)"
  if [[ -z "$latest" ]]; then
    echo "✗ No active session — pass explicit target-path" >&2
    exit 1
  fi

  # Derive filename from URL
  url_basename="${URL##*/}"
  url_basename="${url_basename%%\?*}"
  [[ -z "$url_basename" ]] && url_basename="result.bin"

  TARGET="$SESSIONS_DIR/$latest/results/$url_basename"
fi

mkdir -p "$(dirname "$TARGET")"

printf "↓ %s → %s ... " "$URL" "$TARGET"

http_code="$(curl -sS -L -o "$TARGET" -w "%{http_code}" "$URL" || echo "000")"

if [[ "$http_code" != "200" ]]; then
  rm -f "$TARGET"
  echo "FAIL ($http_code)"
  exit 1
fi

# Output the local path on stdout so caller can capture it
echo "OK"
echo "$TARGET"
