# OpenClaw — Установка и использование Createya

OpenClaw — персональный AI-ассистент который живёт в мессенджерах (WhatsApp, Telegram, Slack и ещё 20+ каналов). В отличие от Claude Code, OpenClaw работает 24/7 как daemon — не нужно запускать IDE. Это правильный выбор если ты хочешь вызывать генерацию прямо из WhatsApp или Telegram.

## Совместимость

| Функция | Статус |
|---------|--------|
| Skill (SKILL.md) | ✅ Полная поддержка (agentskills.io стандарт) |
| MCP сервер | ⚠️ Нет (используется REST fallback) |
| Drag-drop медиа | ✅ Через channel attachments |
| OAuth | ❌ Не нужен (Bearer token в env) |

> **Про MCP:** OpenClaw использует собственный plugin SDK вместо MCP. SKILL.md в этом skill уже содержит автоматический REST fallback — всё работает через обычные `curl` запросы к `api.createya.ai`.

## Требования

- Node.js 24 (рекомендуется) или 22.14+
- OpenClaw CLI: `npm install -g openclaw@latest`
- Аккаунт Createya с API ключом: [createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)

## Установка за 3 шага

### Шаг 1: Установить OpenClaw и настроить канал

```bash
npm install -g openclaw@latest

# Первоначальная настройка (выбор канала — Telegram, WhatsApp и т.д.)
openclaw onboard

# Или сразу с daemon
openclaw onboard --install-daemon
```

### Шаг 2: Установить skill

**Через плагин (рекомендуется):**
```bash
# Из GitHub
openclaw plugins install git+https://github.com/Createya-ai/createya-mcp

# Или из локальной директории (если уже клонировал)
openclaw plugins install ./createya-mcp
```

**Вручную (если плагины не работают):**
```bash
mkdir -p ~/.openclaw/workspace/skills/creative-director
curl -fsSL https://raw.githubusercontent.com/Createya-ai/createya-mcp/main/skills/creative-director/SKILL.md \
  -o ~/.openclaw/workspace/skills/creative-director/SKILL.md
```

### Шаг 3: Настроить API ключ

```bash
# Добавить в ~/.openclaw/workspace/.env
echo "CREATEYA_API_KEY=crya_sk_live_ваш_ключ" >> ~/.openclaw/workspace/.env

# Или прямо в openclaw.json
openclaw config set env.CREATEYA_API_KEY crya_sk_live_ваш_ключ
```

Перезапустить gateway:
```bash
openclaw gateway restart
```

## Проверка установки

```bash
# Посмотреть список skills
openclaw skills list

# Проверить что Createya доступен
openclaw gateway --verbose
```

В чате:
```
/creative-director help
```

## Использование

Skill работает через команды в любом подключённом мессенджере:

```
/creative-director generate nano-banana-pro "yellow hoodie on mannequin, white background"

generate photo yellow hoodie product shot studio lighting

создай фотосессию продукта — жёлтое худи, белый фон
```

Скрипты синхронизации референсов:

```bash
# Создать рабочее пространство
bash ~/.openclaw/workspace/skills/creative-director/scripts/setup.sh

# Загрузить референсы перед работой
bash creative/scripts/sync.sh
```

## Рабочее пространство

Создай папку `creative/` в рабочей директории OpenClaw:

```
~/.openclaw/workspace/
├── skills/creative-director/   # skill files
├── creative/                   # твои рабочие файлы
│   ├── assets/
│   │   ├── models/             # референсные модели
│   │   ├── products/           # товары для съёмки
│   │   └── brand/              # логотипы, стиль
│   ├── sessions/               # история сессий
│   └── MASTER_CONTEXT.md       # бриф проекта
└── .env                        # CREATEYA_API_KEY
```

Запусти `setup.sh` чтобы структура создалась автоматически:
```bash
bash ~/.openclaw/workspace/skills/creative-director/scripts/setup.sh \
  --dir ~/.openclaw/workspace/creative
```

## Контекст в workspace (рекомендуется)

Добавь контекст про Createya в `~/.openclaw/workspace/AGENTS.md`:

```markdown
## Createya API
- Base URL: https://api.createya.ai/v1
- Auth: Bearer token в переменной CREATEYA_API_KEY
- Skill: creative-director — для всех медиа-генераций
- Credit flow: hold → generate → deduct (никогда не пропускать hold)
```

## Медиа через Telegram

Когда присылаешь фото в Telegram-чат OpenClaw, изображение приходит как attachment. Агент может использовать его как референс:

```
[прикрепить фото товара]
сделай эталонный кадр этого товара, белый фон, студийный свет
```

Агент автоматически загрузит фото через `request_upload_url` (если MCP доступен) или попросит тебя указать URL.

## Troubleshooting

**Skill не найден:**
```bash
openclaw plugins list
# Если нет creative-director → переустанови
openclaw plugins install git+https://github.com/Createya-ai/createya-mcp --force
```

**API ключ не работает:**
```bash
# Проверить что переменная установлена
openclaw config get env.CREATEYA_API_KEY

# Тест напрямую
curl -H "Authorization: Bearer $CREATEYA_API_KEY" https://api.createya.ai/v1/me
```

**REST запросы не работают, MCP не найден:**
SKILL.md автоматически переключается на REST когда `mcp__createya__*` инструменты недоступны. Убедись что `CREATEYA_API_KEY` установлен в env.

## Поддержка

- Issues: [github.com/Createya-ai/createya-mcp/issues](https://github.com/Createya-ai/createya-mcp/issues)
- Email: support@createya.ai
- OpenClaw docs: [github.com/openclaw/openclaw/tree/main/docs](https://github.com/openclaw/openclaw/tree/main/docs)
