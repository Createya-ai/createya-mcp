#!/usr/bin/env bash
# Intake: copy an attached file (e.g. one Claude Code received from the user via
# drag-drop / paperclip) into creative/assets/<type>/<slug>/ with auto-numbered name.
#
# Skill calls this when it sees an image attachment. Skill is responsible for
# classifying type (model | product | location | aesthetic | brand) and slug
# from context. This script just does the mechanical move.
#
# Usage:
#   ./scripts/intake.sh <source-path> <type> <slug> [filename-prefix]
#
# Examples:
#   ./scripts/intake.sh /var/folders/.../IMG_5523.jpg products yellow-hoodie-bomma front
#   ./scripts/intake.sh ~/Downloads/sarah.jpg models sarah hero
#
# Output:
#   On success — prints the target path on stdout.
#   On failure — non-zero exit, error to stderr.

set -euo pipefail

SRC="${1:?Usage: $0 <source-path> <type> <slug> [prefix]}"
TYPE="${2:?type is required (models|products|locations|aesthetics|brand)}"
SLUG="${3:?slug is required (e.g. yellow-hoodie-bomma)}"
PREFIX="${4:-}"

[[ -f "$SRC" ]] || { echo "✗ Source not found: $SRC" >&2; exit 1; }

case "$TYPE" in
  models|products|locations|aesthetics|brand) ;;
  *) echo "✗ Invalid type: $TYPE (must be models|products|locations|aesthetics|brand)" >&2; exit 1 ;;
esac

# Sanitize slug (keep alnum + dash, lowercase)
SLUG_CLEAN="$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')"
[[ -n "$SLUG_CLEAN" ]] || { echo "✗ Slug sanitized to empty: $SLUG" >&2; exit 1; }

PROJECT_ROOT="$(pwd)"
DEST_DIR="$PROJECT_ROOT/creative/assets/$TYPE/$SLUG_CLEAN"
mkdir -p "$DEST_DIR"

# Pick next available numbered filename
ext="${SRC##*.}"
ext_lower="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
[[ "$ext_lower" == "jpeg" ]] && ext_lower="jpg"

# Find next index
i=1
while true; do
  if [[ -n "$PREFIX" ]]; then
    candidate="$DEST_DIR/$(printf "%02d" $i)-$PREFIX.$ext_lower"
  else
    candidate="$DEST_DIR/$(printf "%02d" $i).$ext_lower"
  fi
  [[ -f "$candidate" ]] || break
  i=$((i+1))
  if (( i > 99 )); then
    echo "✗ Too many files in $DEST_DIR (>99)" >&2
    exit 1
  fi
done

cp "$SRC" "$candidate"
echo "$candidate"
