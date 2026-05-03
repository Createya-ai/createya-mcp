# Cursor — Установка и использование Createya

Cursor поддерживает MCP для подключения к Createya API. Skill (SKILL.md) не поддерживается — вместо него используются `.cursor/rules/*.mdc` файлы как системный промпт.

## Совместимость

| Функция | Статус |
|---------|--------|
| MCP сервер | ✅ Поддерживается (http/stdio) |
| Skill (SKILL.md) | ❌ Нет — используй `.cursor/rules/*.mdc` |
| Drag-drop файлов | ❌ Нет |
| Vision | ❌ Нет (только через прикрепление изображений в чате) |

## Требования

- Cursor: [cursor.com](https://cursor.com)
- Аккаунт Createya с API ключом: [createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)

## Установка

### Шаг 1: Добавить MCP сервер

Отредактируй или создай `~/.cursor/mcp.json` (глобальный) или `.cursor/mcp.json` (проектный):

```json
{
  "mcpServers": {
    "createya": {
      "url": "https://api.createya.ai/mcp",
      "type": "streamable-http",
      "headers": {
        "Authorization": "Bearer crya_sk_live_ваш_ключ"
      }
    }
  }
}
```

После редактирования: `Cmd+Shift+P` → "Reload Window" или перезапусти Cursor.

### Шаг 2: Добавить rules файл

Скачай готовый `.mdc` файл:

```bash
mkdir -p .cursor/rules
curl -fsSL https://raw.githubusercontent.com/Createya-ai/createya-mcp/main/configs/cursor.mdc \
  -o .cursor/rules/createya.mdc
```

Или создай вручную `.cursor/rules/createya.mdc`:

```yaml
---
description: "Rules for using Createya AI media generation API"
globs: ["**/*"]
alwaysApply: false
---

# Createya Creative Director

When the user asks to generate images, videos, audio, or run a photoshoot:

1. ALWAYS call `get_model_guide` (MCP) before `run_model` to get prompt guidance
2. Use etalon → approval → variations workflow
3. For UGC: add imperfection block (grain, off-center, handheld aesthetic) + skin realism
4. Show credit cost estimate before generating expensive models
5. After each generation — visual QA, max 2 retries with refined prompt

## Workflow
- Interrogate brief if not provided: subject, style, platform, format
- Etalon: locked composition, 250+ word prompt in English
- Variations: image-to-image from approved etalon

## Available MCP tools
- `list_models` — get available models with prompting hints
- `get_model_guide` — full prompt guide for specific model
- `run_model` — generate image or video
- `get_run_status` — poll async generation
- `request_upload_url` — get presigned URL for reference upload

Full guide: https://github.com/Createya-ai/createya-mcp/blob/main/skills/creative-director/SKILL.md
```

### Шаг 3: Проверить подключение

В Cursor Settings → MCP — сервер `createya` должен быть виден.

В чате: "What MCP tools from Createya are available?"

## Использование

### Генерация изображения

```
через Createya MCP сгенерируй изображение: жёлтое худи на манекене, белый фон, студийный свет
model: nano-banana-pro
```

### Полная фотосессия

```
Используй Createya MCP для ecommerce-фотосессии продукта "Yellow Hoodie".
1. Сначала вызови get_model_guide для nano-banana-pro
2. Сгенерируй эталонный кадр: белый фон, frontal eye-level, centered
3. Жди моего одобрения
4. После "ок" — три вариации: 3/4, сбоку, деталь
```

### Просмотр моделей

```
Покажи доступные модели Createya с их возможностями и стоимостью
```

## Загрузка референсов

Так как drag-drop в Cursor не работает для медиа, загружай референсы вручную:

```bash
# Вариант 1: через curl + presigned URL (в Cursor Terminal)
# Попроси агента получить presigned URL, потом загрузи:
curl -X PUT "PRESIGNED_URL" \
  -H "Content-Type: image/jpeg" \
  --data-binary @/path/to/reference.jpg

# Вариант 2: загрузить прямо в Createya Dashboard
# dashboard.createya.ai → Assets → Upload
```

## Конфигурация для команды

Для shared project config добавь в репозиторий `.cursor/mcp.json` с переменными окружения:

```json
{
  "mcpServers": {
    "createya": {
      "url": "https://api.createya.ai/mcp",
      "type": "streamable-http",
      "headers": {
        "Authorization": "Bearer ${CREATEYA_API_KEY}"
      }
    }
  }
}
```

Каждый разработчик устанавливает `CREATEYA_API_KEY` в своём `.env` или shell profile.

## Troubleshooting

**MCP сервер не виден в Settings:**
1. Проверь JSON синтаксис в `mcp.json`
2. Перезапусти Cursor полностью (не просто reload window)
3. Проверь что URL `https://api.createya.ai/mcp` доступен: `curl https://api.createya.ai/mcp`

**Инструменты не работают в чате:**
Cursor Composer должен быть в режиме Agent (не обычный чат). В Composer: убедись что выбран "Agent" режим.

**Ошибка авторизации 401:**
Проверь API ключ: `curl -H "Authorization: Bearer $CREATEYA_API_KEY" https://api.createya.ai/v1/me`

## Поддержка

- Issues: [github.com/Createya-ai/createya-mcp/issues](https://github.com/Createya-ai/createya-mcp/issues)
- Email: support@createya.ai
