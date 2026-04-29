#!/usr/bin/env bash
# Createya MCP installer для Claude Code
# Скачивает skill в ~/.claude/skills/createya/ и подсказывает как добавить MCP в .mcp.json
#
# Запуск:
#   curl -fsSL https://raw.githubusercontent.com/Createya-ai/createya-mcp/main/install.sh | bash

set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills/createya"
REPO_URL="https://github.com/Createya-ai/createya-mcp"
REPO_TAG="${CREATEYA_MCP_TAG:-main}"

echo "════════════════════════════════════════"
echo "║  Createya MCP — Claude Code installer ║"
echo "════════════════════════════════════════"
echo ""

command -v git >/dev/null 2>&1 || { echo "✗ Нужен git"; exit 1; }

mkdir -p "${SKILL_DIR}"

TEMP_DIR=$(mktemp -d)
trap "rm -rf ${TEMP_DIR}" EXIT

echo "↓ Клонирую createya-mcp (${REPO_TAG})..."
git clone --depth 1 --branch "${REPO_TAG}" "${REPO_URL}" "${TEMP_DIR}/createya-mcp" 2>/dev/null

echo "→ Устанавливаю skill в ${SKILL_DIR}..."
cp -r "${TEMP_DIR}/createya-mcp/skills/createya/"* "${SKILL_DIR}/"

echo ""
echo "✓ Skill установлен!"
echo ""
echo "════════════════════════════════════════"
echo "  Что дальше:"
echo "════════════════════════════════════════"
echo ""
echo "  1. Получи API-ключ: https://createya.ai/settings/api-keys"
echo ""
echo "  2. Добавь MCP в Claude Code:"
echo ""
echo "     claude mcp add createya https://api.createya.ai/mcp \\"
echo "       --transport http \\"
echo "       --header \"Authorization: Bearer crya_sk_live_...\""
echo ""
echo "  3. В чате — пробуй:"
echo "     «Сгенерь картинку кот на луне через Createya»"
echo ""
echo "  📚 Доки: https://createya.ai/api"
echo "  💬 Поддержка: support@createya.ai"
echo ""
