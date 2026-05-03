#!/usr/bin/env bash
# Createya — install skills (createya + creative-director) в local skill folders
# поддерживаемых агентов: Claude Code, OpenClaw, OpenAI Codex CLI.
#
# Также подсказывает как добавить MCP в Claude Desktop / Cursor / Cline / Windsurf
# (для них skill format не поддерживается — только MCP server config).
#
# Запуск:
#   curl -fsSL https://raw.githubusercontent.com/Createya-ai/createya-mcp/main/install.sh | bash

set -euo pipefail

REPO_URL="https://github.com/Createya-ai/createya-mcp"
REPO_TAG="${CREATEYA_MCP_TAG:-main}"

echo "═══════════════════════════════════════════════════════"
echo "║  Createya — skills + MCP installer                  ║"
echo "═══════════════════════════════════════════════════════"
echo ""

command -v git >/dev/null 2>&1 || { echo "✗ Нужен git"; exit 1; }

TEMP_DIR=$(mktemp -d)
trap "rm -rf ${TEMP_DIR}" EXIT

echo "↓ Клонирую createya-mcp (${REPO_TAG})..."
git clone --depth 1 --branch "${REPO_TAG}" "${REPO_URL}" "${TEMP_DIR}/createya-mcp" 2>/dev/null

INSTALLED=()

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
  INSTALLED+=("Claude Code: ~/.claude/skills/{createya,creative-director}/")
fi

# ── OpenClaw ─────────────────────────────────────────────────────────────────
if [[ -d "${HOME}/.openclaw/workspace" ]] || command -v openclaw >/dev/null 2>&1; then
  echo "→ OpenClaw detected"
  install_skill createya          "${HOME}/.openclaw/workspace/skills/createya"
  install_skill creative-director "${HOME}/.openclaw/workspace/skills/creative-director"
  INSTALLED+=("OpenClaw: ~/.openclaw/workspace/skills/{createya,creative-director}/")
fi

# ── OpenAI Codex CLI ─────────────────────────────────────────────────────────
if [[ -d "${HOME}/.codex" ]] || command -v codex >/dev/null 2>&1; then
  echo "→ OpenAI Codex CLI detected"
  # Codex uses AGENTS.md in repo root + reads SKILL.md from skills/ paths.
  # We install both skills + drop AGENTS.md in user home so projects pick it up.
  install_skill createya          "${HOME}/.codex/skills/createya"
  install_skill creative-director "${HOME}/.codex/skills/creative-director"
  cp "${TEMP_DIR}/createya-mcp/AGENTS.md" "${HOME}/.codex/AGENTS.md"
  INSTALLED+=("OpenAI Codex: ~/.codex/skills/{createya,creative-director}/ + AGENTS.md")
fi

# ── Cursor (skills via .cursor/skills/ — partial support) ─────────────────────
if [[ -d "${HOME}/.cursor" ]] || command -v cursor >/dev/null 2>&1; then
  echo "→ Cursor detected — installing skill (partial support — see docs/non-claude-agents.md)"
  install_skill createya          "${HOME}/.cursor/skills/createya"
  install_skill creative-director "${HOME}/.cursor/skills/creative-director"
  INSTALLED+=("Cursor: ~/.cursor/skills/{createya,creative-director}/ (partial)")
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
if (( ${#INSTALLED[@]} == 0 )); then
  echo "⚠ No skill-supporting agent detected (Claude Code, OpenClaw, Codex, Cursor)."
  echo "   You can still use MCP server with any of these tools — see configs/."
else
  echo "✓ Skills installed in:"
  for line in "${INSTALLED[@]}"; do
    echo "   • $line"
  done
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  Next steps"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "  1. Get an API key: https://createya.ai/settings/api-keys"
echo "     Format: crya_sk_live_<32hex>"
echo ""
echo "  2. Configure MCP server in your tool:"
echo ""
echo "     • Claude Code:"
echo "       claude mcp add createya https://api.createya.ai/mcp \\"
echo "         --transport http --header \"Authorization: Bearer crya_sk_live_...\""
echo ""
echo "     • Claude Desktop / Claude.ai web:"
echo "       Add custom connector at https://api.createya.ai/mcp"
echo "       (OAuth flow — paste API key when prompted)"
echo ""
echo "     • Cursor / Cline / Windsurf / Codex / Continue / Gemini CLI:"
echo "       See configs/ folder in this repo (one JSON snippet per tool)"
echo ""
echo "     • OpenClaw:"
echo "       MCP support TBD — skills already work via REST API directly"
echo ""
echo "  3. Initialize a creative workspace in your project (optional, for"
echo "     creative-director skill):"
echo ""
echo "     cd ~/my-photo-project"
echo "     ~/.claude/skills/creative-director/scripts/setup.sh"
echo ""
echo "  4. Try in chat:"
echo "     «Сгенерь картинку кот на луне через Createya»"
echo "     «Сделай ecommerce фотосессию жёлтого худи»"
echo ""
echo "  📚 Docs: https://createya.ai/api"
echo "  📦 Repo: ${REPO_URL}"
echo "  💬 Support: support@createya.ai"
echo ""
