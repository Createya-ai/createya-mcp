#!/usr/bin/env bash
# Createya — one-command installer: skills + MCP server
#
# Usage:
#   curl -fsSL https://api.createya.ai/install | bash -s -- crya_sk_live_YOUR_KEY
#
# The API key argument is optional — if omitted, MCP is registered without auth
# (useful when key is already set in env or when using OAuth via Claude Desktop).

set -euo pipefail

API_KEY="${1:-}"
REPO_URL="https://github.com/Createya-ai/createya-mcp"
REPO_TAG="${CREATEYA_MCP_TAG:-main}"
MCP_URL="https://api.createya.ai/mcp"

echo "═══════════════════════════════════════════════════════"
echo "║  Createya — skills + MCP installer                  ║"
echo "═══════════════════════════════════════════════════════"
echo ""

command -v git >/dev/null 2>&1 || { echo "✗ git is required"; exit 1; }

TEMP_DIR=$(mktemp -d)
trap 'rm -rf ${TEMP_DIR}' EXIT

echo "↓ Cloning createya-mcp (${REPO_TAG})..."
git clone --depth 1 --branch "${REPO_TAG}" "${REPO_URL}" "${TEMP_DIR}/createya-mcp" 2>/dev/null

INSTALLED=()
MCP_REGISTERED=false

# ── Helper: copy skills/<name>/* into target dir ──────────────────────────────
install_skill() {
  local skill_name="$1" target_dir="$2"
  mkdir -p "$target_dir"
  cp -r "${TEMP_DIR}/createya-mcp/skills/${skill_name}/"* "$target_dir/"
}

# ── Claude Code ──────────────────────────────────────────────────────────────
if [[ -d "${HOME}/.claude" ]] || command -v claude >/dev/null 2>&1; then
  echo "→ Claude Code detected"
  install_skill createya          "${HOME}/.claude/skills/createya"
  install_skill creative-director "${HOME}/.claude/skills/creative-director"
  INSTALLED+=("Skills: ~/.claude/skills/{createya,creative-director}/")

  if command -v claude >/dev/null 2>&1; then
    if [[ -n "${API_KEY}" ]]; then
      echo "→ Registering MCP server with your API key..."
      claude mcp add createya "${MCP_URL}" \
        --transport http \
        --header "Authorization: Bearer ${API_KEY}" \
        --scope user 2>/dev/null \
        && MCP_REGISTERED=true \
        || echo "  ⚠ MCP registration failed — run manually (see below)"
    else
      echo "→ Registering MCP server (no auth — add key later or use OAuth)..."
      claude mcp add createya "${MCP_URL}" \
        --transport http \
        --scope user 2>/dev/null \
        && MCP_REGISTERED=true \
        || echo "  ⚠ MCP registration failed — run manually (see below)"
    fi
    [[ "${MCP_REGISTERED}" == true ]] && INSTALLED+=("MCP: createya → ${MCP_URL}")
  fi
fi

# ── OpenClaw ─────────────────────────────────────────────────────────────────
if [[ -d "${HOME}/.openclaw/workspace" ]] || command -v openclaw >/dev/null 2>&1; then
  echo "→ OpenClaw detected"
  install_skill createya          "${HOME}/.openclaw/workspace/skills/createya"
  install_skill creative-director "${HOME}/.openclaw/workspace/skills/creative-director"
  INSTALLED+=("OpenClaw skills: ~/.openclaw/workspace/skills/{createya,creative-director}/")
fi

# ── OpenAI Codex CLI ─────────────────────────────────────────────────────────
if [[ -d "${HOME}/.codex" ]] || command -v codex >/dev/null 2>&1; then
  echo "→ OpenAI Codex CLI detected"
  install_skill createya          "${HOME}/.codex/skills/createya"
  install_skill creative-director "${HOME}/.codex/skills/creative-director"
  cp "${TEMP_DIR}/createya-mcp/AGENTS.md" "${HOME}/.codex/AGENTS.md"
  INSTALLED+=("Codex skills: ~/.codex/skills/{createya,creative-director}/ + AGENTS.md")
fi

# ── Cursor ────────────────────────────────────────────────────────────────────
if [[ -d "${HOME}/.cursor" ]] || command -v cursor >/dev/null 2>&1; then
  echo "→ Cursor detected"
  install_skill createya          "${HOME}/.cursor/skills/createya"
  install_skill creative-director "${HOME}/.cursor/skills/creative-director"
  INSTALLED+=("Cursor skills: ~/.cursor/skills/{createya,creative-director}/")
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
if (( ${#INSTALLED[@]} == 0 )); then
  echo "⚠ No supported agent detected (Claude Code, OpenClaw, Codex, Cursor)."
  echo "  Connect MCP manually — see configs/ in the repo."
else
  echo "✓ Installed:"
  for line in "${INSTALLED[@]}"; do
    echo "   • $line"
  done
fi

echo ""

if [[ "${MCP_REGISTERED}" == false ]] && ([[ -d "${HOME}/.claude" ]] || command -v claude >/dev/null 2>&1); then
  echo "  To register the MCP server manually:"
  echo ""
  if [[ -n "${API_KEY}" ]]; then
    echo "  claude mcp add createya ${MCP_URL} \\"
    echo "    --transport http \\"
    echo "    --header \"Authorization: Bearer ${API_KEY}\" \\"
    echo "    --scope user"
  else
    echo "  claude mcp add createya ${MCP_URL} \\"
    echo "    --transport http \\"
    echo "    --header \"Authorization: Bearer crya_sk_live_...\" \\"
    echo "    --scope user"
    echo ""
    echo "  Get your key: https://createya.ai/settings/api-keys"
  fi
  echo ""
fi

if [[ -z "${API_KEY}" ]] && [[ "${MCP_REGISTERED}" == true ]]; then
  echo "  ⚠ MCP registered without an API key."
  echo "  Add your key: https://createya.ai/settings/api-keys"
  echo "  Then re-run: claude mcp add createya ${MCP_URL} \\"
  echo "    --transport http --header \"Authorization: Bearer crya_sk_live_...\" --scope user"
  echo ""
fi

echo "  Try in chat:"
echo "    «Generate a product photo of a yellow hoodie for e-commerce»"
echo "    «Make a lookbook shoot, 6 outfits on an AI model»"
echo ""
echo "  📚 Docs: https://createya.ai/api"
echo "  📦 Repo: ${REPO_URL}"
echo "  💬 Support: support@createya.ai"
echo ""
