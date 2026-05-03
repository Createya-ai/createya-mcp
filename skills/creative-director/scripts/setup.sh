#!/usr/bin/env bash
# Creative Director — interactive setup in current project directory.
#
# Run this from the directory where you want your creative workspace:
#   cd ~/my-photo-project
#   ~/.claude/skills/creative-director/scripts/setup.sh
#
# What it creates:
#   ./creative/                       — local workspace (assets, sessions)
#   ./MASTER_CONTEXT.md               — brand voice, learnings, custom presets refs
#   ./.env                            — CREATEYA_API_KEY (gitignored)
#   ./logs/                           — generation history
#   ./.gitignore (appended)           — protects .env, .skill-state, results cache

set -euo pipefail

PROJECT_ROOT="$(pwd)"
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "════════════════════════════════════════════════════════════"
echo "║  Creative Director — workspace setup                       ║"
echo "║  Project: $PROJECT_ROOT"
echo "════════════════════════════════════════════════════════════"
echo ""

# --- 1. Verify prerequisites ----------------------------------------------
command -v curl >/dev/null 2>&1 || { echo "✗ curl required"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "✗ jq required (brew install jq)"; exit 1; }

# --- 2. .env --------------------------------------------------------------
if [[ ! -f "$PROJECT_ROOT/.env" ]]; then
  cat > "$PROJECT_ROOT/.env" <<EOF
# Createya API key (https://createya.ai/settings/api-keys)
# Format: crya_sk_live_<32hex>
CREATEYA_API_KEY=

# Optional: override gateway URL (defaults to PROD)
# CREATEYA_API_BASE=https://api-dev.createya.ai
EOF
  chmod 600 "$PROJECT_ROOT/.env"
  echo "✓ Created .env (placeholder)"
fi

# Prompt for API key if missing — only when running interactively (have a tty).
# In CI / piped runs we skip the prompt and let user fill .env manually.
if ! grep -q "^CREATEYA_API_KEY=crya_sk" "$PROJECT_ROOT/.env"; then
  if [[ -t 0 ]]; then
    echo ""
    echo "Need a key? Get one at: https://createya.ai/settings/api-keys"
    printf "Paste your Createya API key (input hidden, Enter to skip): "
    api_key=""
    read -rs api_key || true
    printf "\n"

    if [[ -n "$api_key" ]]; then
      if [[ ! "$api_key" =~ ^crya_sk_(live|test)_[a-f0-9]{32}$ ]]; then
        echo "⚠ Key format looks unusual (expected crya_sk_live_<32hex>). Saving anyway."
      fi
      # Use sed with delimiter | to avoid issues with key chars.
      sed "s|^CREATEYA_API_KEY=.*|CREATEYA_API_KEY=$api_key|" "$PROJECT_ROOT/.env" > "$PROJECT_ROOT/.env.tmp"
      mv "$PROJECT_ROOT/.env.tmp" "$PROJECT_ROOT/.env"
      chmod 600 "$PROJECT_ROOT/.env"
      echo "✓ Saved API key to .env"
      unset api_key
    else
      echo "⚠ Skipped — paste key into .env manually before generating."
    fi
  else
    echo "⚠ Non-interactive run — skipping API key prompt. Edit .env manually."
  fi
fi

# --- 3. Workspace folders -------------------------------------------------
mkdir -p \
  "$PROJECT_ROOT/creative/assets/models" \
  "$PROJECT_ROOT/creative/assets/products" \
  "$PROJECT_ROOT/creative/assets/locations" \
  "$PROJECT_ROOT/creative/assets/aesthetics" \
  "$PROJECT_ROOT/creative/assets/brand" \
  "$PROJECT_ROOT/creative/sessions" \
  "$PROJECT_ROOT/logs"
echo "✓ Created creative/ workspace"

# Initial empty index — sync.sh will populate it
if [[ ! -f "$PROJECT_ROOT/creative/.assets-index.json" ]]; then
  echo '{}' > "$PROJECT_ROOT/creative/.assets-index.json"
  echo "✓ Created creative/.assets-index.json"
fi

# Touch logs file so it exists
[[ -f "$PROJECT_ROOT/logs/createya-api.jsonl" ]] || touch "$PROJECT_ROOT/logs/createya-api.jsonl"

# --- 4. MASTER_CONTEXT.md -------------------------------------------------
if [[ ! -f "$PROJECT_ROOT/MASTER_CONTEXT.md" ]]; then
  cat > "$PROJECT_ROOT/MASTER_CONTEXT.md" <<'EOF'
# Master Context — Creative Director workspace

> One place for the agent to capture brand voice, default settings, and
> learnings while using this workspace. Edit freely.

## Brand voice (optional)

- **Tone:**
- **Audience:**
- **Words to use / avoid:**

## Workspace structure

Drop reference images into `creative/assets/`:
- `models/` — face/body photos to recreate or use
- `products/` — товары (по подпапкам: `products/yellow-hoodie-bomma/`)
- `locations/` — локации (по подпапкам: `locations/loft-studio-ny/`)
- `aesthetics/` — мудборды, стилевые референсы
- `brand/` — логотипы, fonts (для overlays)

When you (or the user) drop a new image into the chat, the agent classifies
it and copies into the right subfolder, then runs `./scripts/sync.sh`.

## Defaults

- **Default image model:** `nano-banana-pro` (~18 credits)
- **Default video model:** _(set when first used)_
- **Default aspect ratio:** _(set when first used)_

## Generation history

See `logs/createya-api.jsonl` for every run with `creditsCharged`. Use it for
cost estimation before new generations.

## Custom presets

User-created presets live in `~/.claude/skills/creative-director/presets/<type>/_custom/`.
Reference them by slug — agent finds them automatically.

## Changelog

EOF
  echo "✓ Created MASTER_CONTEXT.md"
fi

# --- 5. .gitignore --------------------------------------------------------
GITIGNORE="$PROJECT_ROOT/.gitignore"
touch "$GITIGNORE"
add_to_gitignore() {
  local pattern="$1"
  grep -qxF "$pattern" "$GITIGNORE" || echo "$pattern" >> "$GITIGNORE"
}
add_to_gitignore ".env"
add_to_gitignore ".env.tmp"
add_to_gitignore "creative/.assets-index.json"
add_to_gitignore "creative/sessions/*/results/"
add_to_gitignore ".skill-state/"
echo "✓ Updated .gitignore"

# --- 6. Verify connectivity (optional) ------------------------------------
source "$PROJECT_ROOT/.env" 2>/dev/null || true
if [[ -n "${CREATEYA_API_KEY:-}" ]]; then
  BASE="${CREATEYA_API_BASE:-https://api.createya.ai}"
  echo ""
  echo "→ Testing connection to $BASE/v1/me..."
  code="$(curl -sS -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $CREATEYA_API_KEY" "$BASE/v1/me" || echo "000")"
  if [[ "$code" == "200" ]]; then
    echo "✓ Connection OK"
  else
    echo "⚠ Got HTTP $code — check key at https://createya.ai/settings/api-keys"
  fi
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "║  Setup complete                                            ║"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Drop reference images into chat — agent will classify and store them"
echo "  2. Or place files manually in creative/assets/<type>/<name>/ then run:"
echo "     ./scripts/sync.sh  (or ask the agent: 'sync references')"
echo "  3. Start a creative session: tell the agent what you want to create"
echo ""
echo "MCP setup (if not already done):"
echo "  curl -fsSL https://api.createya.ai/install-mcp | bash -s -- \$CREATEYA_API_KEY"
echo ""
