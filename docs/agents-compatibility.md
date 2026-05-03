# Совместимость с AI-агентами

`creative-director` skill работает во всех перечисленных агентах. Уровень поддержки зависит от возможностей агента.

## Сводная таблица

| Агент | MCP | Skill (SKILL.md) | Drag-drop медиа | Vision | Детали |
|-------|:---:|:-----------------:|:---------------:|:------:|--------|
| **Claude Code CLI** | ✅ | ✅ | ❌ | ✅ (локальный Read) | [docs/claude-code.md](claude-code.md) |
| **Claude Code Desktop** | ✅ | ✅ | ✅ | ✅ | [docs/claude-desktop.md](claude-desktop.md) |
| **Claude.ai web** | ✅ (Pro+) | ❌ → Projects | ✅ (как вложение) | ✅ | [docs/claude-ai-web.md](claude-ai-web.md) |
| **OpenClaw** | ⚠️ REST fallback | ✅ | ✅ (через каналы) | ⚠️ | [docs/openclaw.md](openclaw.md) |
| **Cursor** | ✅ | ❌ → .mdc rules | ❌ | ❌ | [docs/cursor.md](cursor.md) |
| **Cline** | ✅ | ❌ | ❌ | ❌ | см. ниже |
| **Windsurf** | ✅ | ❌ | ❌ | ❌ | см. ниже |
| **Continue.dev** | ✅ | ❌ | ❌ | ❌ | см. ниже |
| **OpenAI Codex CLI** | ❌ | ❌ | ❌ | ❌ | AGENTS.md fallback |
| **Gemini CLI** | ✅ | ❌ | ❌ | ❌ | GEMINI.md fallback |

**Легенда:** ✅ = поддерживается нативно, ⚠️ = частично/обходной путь, ❌ = не поддерживается

## Установка MCP (одна команда для всех)

```bash
curl -fsSL https://api.createya.ai/install-mcp | bash -s -- crya_sk_live_ваш_ключ
```

Скрипт автоматически определит установленные агенты и пропишет MCP config.

После рестарта агента — `mcp__createya__*` инструменты доступны.

---

## Claude Code (CLI + Desktop)

Полная поддержка — нативная среда для этого skill.

```bash
# CLI
claude plugin marketplace add Createya-ai/createya-mcp
claude plugin install creative-director@createya-mcp

# MCP
claude mcp add createya --transport http https://api.createya.ai/mcp \
  --header "Authorization: Bearer crya_sk_live_..."
```

Подробно: [docs/claude-code.md](claude-code.md) | [docs/claude-desktop.md](claude-desktop.md)

---

## OpenClaw

OpenClaw — персональный AI-агент в мессенджерах (WhatsApp, Telegram, Slack, ещё 20+ каналов). Skill format поддерживается через стандарт [agentskills.io](https://agentskills.io). MCP не поддерживается — skill автоматически использует REST fallback через `curl`.

### Установка

```bash
# Установить OpenClaw
npm install -g openclaw@latest
openclaw onboard --install-daemon

# Установить skill
openclaw plugins install git+https://github.com/Createya-ai/createya-mcp

# Настроить API ключ
openclaw config set env.CREATEYA_API_KEY crya_sk_live_ваш_ключ

# Перезапустить
openclaw gateway restart
```

### Структура skill в workspace

```
~/.openclaw/workspace/skills/creative-director/
├── SKILL.md              # основные инструкции (REST fallback включён)
├── references/           # пресеты, гайды
├── scripts/
│   ├── setup.sh          # создать рабочее пространство
│   └── sync.sh           # синхронизировать референсы
└── presets/              # 141 профессиональный пресет
```

### Добавить контекст в AGENTS.md

Для лучшего результата добавь в `~/.openclaw/workspace/AGENTS.md`:

```markdown
## Createya API
- Base URL: https://api.createya.ai/v1
- Auth: Bearer token в переменной CREATEYA_API_KEY
- Для медиа-генерации использовать skill: creative-director
```

### Каналы и медиа

OpenClaw получает фото из мессенджеров как channel attachments. В Telegram:
```
[прикрепить фото товара]
используй это как референс, сделай ecommerce фотосессию
```

Агент загрузит фото через REST `POST /v1/uploads/presigned` и использует CDN URL как `start_image_url`.

Подробно: [docs/openclaw.md](openclaw.md)

---

## Cursor

MCP поддерживается. Skill (SKILL.md) — нет, используй `.cursor/rules/*.mdc`.

```bash
# Скачать готовый .mdc файл
mkdir -p .cursor/rules
curl -fsSL https://raw.githubusercontent.com/Createya-ai/createya-mcp/main/configs/cursor.mdc \
  -o .cursor/rules/createya.mdc
```

Добавить в `.cursor/mcp.json`:
```json
{
  "mcpServers": {
    "createya": {
      "url": "https://api.createya.ai/mcp",
      "type": "streamable-http",
      "headers": { "Authorization": "Bearer crya_sk_live_..." }
    }
  }
}
```

Подробно: [docs/cursor.md](cursor.md)

---

## Cline (VS Code extension)

```bash
# Установить
code --install-extension saoudrizwan.claude-dev
```

Добавить в Cline MCP Settings (VS Code Settings → Cline → MCP):
```json
{
  "createya": {
    "url": "https://api.createya.ai/mcp",
    "headers": { "Authorization": "Bearer crya_sk_live_..." }
  }
}
```

Или через `cline_mcp_settings.json`:
- macOS: `~/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json`
- Windows: `%APPDATA%\Code\User\globalStorage\saoudrizwan.claude-dev\settings\cline_mcp_settings.json`

---

## Windsurf

Добавить в `~/.codeium/windsurf/mcp_server_config.json`:
```json
{
  "mcpServers": {
    "createya": {
      "url": "https://api.createya.ai/mcp",
      "headers": { "Authorization": "Bearer crya_sk_live_..." }
    }
  }
}
```

Добавить контекст в `.windsurfrules` (корень проекта):
```markdown
When generating media use Createya MCP tools (mcp__createya__*).
Always call get_model_guide before run_model.
Etalon → approval → variations workflow.
```

---

## Continue.dev

```bash
npm i -g @continuedev/cli
```

Добавить в `~/.continue/config.yaml`:
```yaml
mcpServers:
  - name: createya
    url: https://api.createya.ai/mcp
    headers:
      Authorization: "Bearer crya_sk_live_..."
```

---

## Gemini CLI

```bash
npm install -g @google-labs/gemini-cli
```

Добавить в `~/.gemini/settings.json`:
```json
{
  "mcpServers": {
    "createya": {
      "httpUrl": "https://api.createya.ai/mcp",
      "headers": { "Authorization": "Bearer crya_sk_live_..." }
    }
  }
}
```

Добавить контекст в `GEMINI.md` (корень проекта) — аналог CLAUDE.md.

---

## OpenAI Codex CLI

MCP не поддерживается. SKILL.md не поддерживается. Используй AGENTS.md:

```bash
mkdir -p ~/.codex
curl -fsSL https://raw.githubusercontent.com/Createya-ai/createya-mcp/main/AGENTS.md \
  -o ~/.codex/AGENTS.md
```

AGENTS.md содержит copy-paste промпты для всех сценариев (фотосессия, UGC, видео, character sheet).

---

## Что НЕТ без Claude Code skill

| Функция | Статус без skill |
|---------|-----------------|
| Автоматический drag-drop intake | ❌ — файл нужно указать явно |
| Локальный workspace (`creative/`) | ❌ — создавай руками через `setup.sh` |
| Auto-classification файлов | ❌ — указывай агенту явно |
| Готовые пресеты (141 штук) | ❌ — описывай параметры в промпте |
| Vision QA loop (авто-ретрай) | ❌ — делай вручную |
| Credit gate перед генерацией | ❌ — спрашивай агента "сколько кредитов?" |

## Что ЕСТЬ через MCP везде

| Функция | Статус |
|---------|--------|
| Все модели (FLUX, Kling, Veo, Sora, Seedance, Midjourney, etc.) | ✅ |
| Загрузка референсов (`request_upload_url`) | ✅ |
| Polling async-генераций | ✅ |
| Prompt guides per model (`get_model_guide`) | ✅ |
| Биллинг / кредиты | ✅ |

---

## Поддержка

- Issues: [github.com/Createya-ai/createya-mcp/issues](https://github.com/Createya-ai/createya-mcp/issues)
- Email: support@createya.ai
- Docs: [createya.ai/docs](https://createya.ai/docs)
