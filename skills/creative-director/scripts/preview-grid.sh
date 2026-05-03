#!/usr/bin/env bash
# Generate an HTML preview grid of all files in a session's results/ folder
# and open it in the default browser. Replaces "open <url>" loop with one tab.
#
# Usage:
#   ./scripts/preview-grid.sh                        # latest session
#   ./scripts/preview-grid.sh <session-folder-name>  # specific session

set -euo pipefail

PROJECT_ROOT="$(pwd)"
SESSIONS_DIR="$PROJECT_ROOT/creative/sessions"
[[ -d "$SESSIONS_DIR" ]] || { echo "✗ No creative/sessions/ — run setup.sh first" >&2; exit 1; }

SESSION="${1:-}"
if [[ -z "$SESSION" ]]; then
  SESSION="$(ls -1t "$SESSIONS_DIR" 2>/dev/null | head -1)"
  [[ -z "$SESSION" ]] && { echo "✗ No sessions yet" >&2; exit 1; }
fi

RESULTS_DIR="$SESSIONS_DIR/$SESSION/results"
[[ -d "$RESULTS_DIR" ]] || { echo "✗ No results/ in $SESSION" >&2; exit 1; }

OUTPUT="$SESSIONS_DIR/$SESSION/preview.html"

# Collect image/video files
shopt -s nullglob
FILES=("$RESULTS_DIR"/*.{jpg,jpeg,png,webp,mp4,mov,webm})
shopt -u nullglob

if (( ${#FILES[@]} == 0 )); then
  echo "✗ No previewable files in $RESULTS_DIR" >&2
  exit 1
fi

# Generate HTML
cat > "$OUTPUT" <<HTMLHEAD
<!DOCTYPE html>
<html lang="ru"><head><meta charset="utf-8">
<title>Creative Director — $SESSION</title>
<style>
  *{box-sizing:border-box;margin:0;padding:0}
  body{background:#0a0a0a;color:#fff;font-family:-apple-system,sans-serif;padding:24px}
  h1{font-size:14px;font-weight:500;color:#888;margin-bottom:16px}
  .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:12px}
  .item{background:#141414;border:1px solid #222;border-radius:8px;overflow:hidden;display:flex;flex-direction:column}
  .item img,.item video{width:100%;height:auto;display:block;cursor:pointer}
  .label{padding:8px 12px;font-size:12px;color:#888;font-family:monospace;border-top:1px solid #222}
</style></head><body>
<h1>$SESSION — ${#FILES[@]} файлов</h1>
<div class="grid">
HTMLHEAD

for f in "${FILES[@]}"; do
  name="$(basename "$f")"
  ext="${name##*.}"
  case "${ext,,}" in
    mp4|mov|webm)
      echo "  <div class=\"item\"><video src=\"results/$name\" controls></video><div class=\"label\">$name</div></div>" >> "$OUTPUT"
      ;;
    *)
      echo "  <div class=\"item\"><a href=\"results/$name\" target=\"_blank\"><img src=\"results/$name\"></a><div class=\"label\">$name</div></div>" >> "$OUTPUT"
      ;;
  esac
done

cat >> "$OUTPUT" <<'HTMLTAIL'
</div>
</body></html>
HTMLTAIL

echo "✓ Generated $OUTPUT"

# Open in default browser
case "$(uname -s)" in
  Darwin*) open "$OUTPUT" ;;
  Linux*)  xdg-open "$OUTPUT" 2>/dev/null || echo "  Open manually: $OUTPUT" ;;
  *)       echo "  Open manually: $OUTPUT" ;;
esac
