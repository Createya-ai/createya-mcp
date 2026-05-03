# Claude Code — Установка и использование Createya

Claude Code — основная среда для creative-director skill. Полная поддержка MCP, SKILL.md, vision через `Read`, автоматический drag-drop intake.

## Совместимость

| Функция | Статус |
|---------|--------|
| Skill (SKILL.md) | ✅ Полная поддержка (нативная) |
| MCP сервер | ✅ Полная поддержка (http/sse/stdio) |
| OAuth Bearer | ✅ Да |
| Drag-drop файлов | ✅ Desktop app (Code вкладка) |
| Vision (Read image) | ✅ Нативно через `Read` tool |

## Требования

- Claude Code CLI / Desktop app (macOS/Windows/Linux)
- Аккаунт Createya с API ключом: [createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)

## Установка

### Шаг 1: Установить Claude Code

**macOS / Linux:**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**macOS Homebrew:**
```bash
brew install --cask claude-code
```

**Windows PowerShell:**
```powershell
irm https://claude.ai/install.ps1 | iex
```

**VS Code Extension:**
```bash
code --install-extension anthropic.claude-code
```

**Desktop app:** [claude.ai/download](https://claude.ai/download) — скачать desktop приложение.

### Шаг 2: Установить plugin

```bash
# Добавить marketplace + установить plugin
claude plugin marketplace add Createya-ai/createya-mcp
claude plugin install creative-director@createya-mcp
```

Или установить через `/plugin` в чате Claude Code:
```
/plugin install creative-director@createya-mcp
```

После установки перезагрузить skills:
```
/reload-plugins
```

### Шаг 3: Подключить MCP сервер

```bash
claude mcp add createya \
  --transport http \
  https://api.createya.ai/mcp \
  --header "Authorization: Bearer crya_sk_live_ваш_ключ"
```

Проверить что сервер доступен:
```bash
claude mcp list
claude mcp get createya
```

### Шаг 4: Создать рабочее пространство

```bash
cd ~/my-photo-project
bash ~/.claude/plugins/creative-director/scripts/setup.sh
```

Или если установил через install.sh:
```bash
bash ~/.claude/skills/creative-director/scripts/setup.sh
```

Создаётся структура:
```
creative/
├── assets/
│   ├── models/      # референсные модели
│   ├── products/    # товары
│   ├── locations/   # локации
│   ├── aesthetics/  # референсы стиля
│   └── brand/       # брендинг
├── sessions/        # история сессий
└── MASTER_CONTEXT.md
```

## Использование

### Базовый вызов

```
/creative-director

создай фотосессию продукта — жёлтое худи, белый фон, студийный свет

generate ecommerce photo of yellow hoodie
```

### С аргументами

```
/creative-director yellow hoodie product shot, white background

/creative-director --model nano-banana-pro "lifestyle photo, blue jeans, urban setting"
```

### Drag-drop референс (Desktop app)

1. Перетащи фото в prompt field
2. Напиши задачу: "используй это фото как референс модели, создай три ракурса"

Агент сам вызовет `Read` на файл, получит vision-анализ, загрузит через `request_upload_url` и использует как referenceImages.

### Синхронизация папки с референсами

```bash
# Положи референсы в creative/assets/models/
# Запусти синхронизацию
bash creative/scripts/sync.sh

# Или только одну папку
bash creative/scripts/sync.sh models/sarah
```

После синхронизации агент видит CDN URL всех референсов в `.assets-index.json` и может использовать их напрямую.

## Примеры сценариев

### Фотосессия товара

```
Сделай ecommerce-фотосессию: жёлтое худи, материал fleece, унисекс.
Эталонный кадр: белый бесшовный фон, frontal eye-level, centered 70% canvas.
После одобрения — 4 вариации: 3/4 угол, сбоку, сзади, деталь.
```

### Модель по референсу

```bash
# Положи фото в creative/assets/models/sarah.jpg
bash creative/scripts/sync.sh models/sarah.jpg
```
```
В creative/assets/models/ есть sarah.jpg.
Воссоздай модель, сделай три ракурса в разных образах для лукбука.
```

### UGC видео

```
UGC-отзыв на наушники. Девушка 22-25 лет, iPhone selfie aesthetic.
Импульс: "These are crazy comfortable, I can't take them off."
10 секунд, 9:16, с аудио.
```

## Конфигурация

### Глобальный config

`~/.claude/settings.json` — добавить MCP servers и env:

```json
{
  "mcpServers": {
    "createya": {
      "transport": "http",
      "url": "https://api.createya.ai/mcp",
      "headers": {
        "Authorization": "Bearer ${CREATEYA_API_KEY}"
      }
    }
  }
}
```

### Project config

`.claude/settings.json` в корне проекта — для team-specific настроек.

### Env vars

```bash
# ~/.zshrc или ~/.bashrc
export CREATEYA_API_KEY=crya_sk_live_ваш_ключ
```

## Проверка установки

```bash
# Список установленных plugins
claude plugin list

# MCP статус
claude mcp list

# В чате
/creative-director help
What MCP tools from Createya are available?
```

## Troubleshooting

**MCP инструменты недоступны (`mcp__createya__*` не работают):**
```bash
# Проверить что сервер добавлен
claude mcp list

# Пересоздать
claude mcp remove createya
claude mcp add createya --transport http https://api.createya.ai/mcp \
  --header "Authorization: Bearer $CREATEYA_API_KEY"
```

**Skill не находится в `/`:**
```
/reload-plugins
/plugin list
```

**Vision не работает (Read на изображение):**
Vision работает только через Desktop app или CLI с локальным файлом. Для URL — скачай файл сначала:
```bash
curl -L "https://example.com/photo.jpg" -o /tmp/ref.jpg
```
Потом в чате: "прочитай /tmp/ref.jpg и опиши модель".

## Поддержка

- Issues: [github.com/Createya-ai/createya-mcp/issues](https://github.com/Createya-ai/createya-mcp/issues)
- Email: support@createya.ai
- Claude Code docs: [code.claude.com/docs](https://code.claude.com/docs)
