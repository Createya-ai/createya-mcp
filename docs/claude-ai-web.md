# Claude.ai (web) — Использование Createya

Claude.ai — веб-интерфейс. Поддерживает remote MCP connectors (на Pro и выше) и Projects с custom instructions. SKILL.md не поддерживается — используй Projects как обходной путь.

## Совместимость

| Функция | Статус |
|---------|--------|
| MCP (remote) | ✅ Custom connectors (Pro+) |
| Skill (SKILL.md) | ❌ Нет — используй Projects instructions |
| Drag-drop файлов | ✅ Вложения в чат |
| Vision | ✅ Через прикреплённые изображения |
| OAuth flow | ✅ Графический wizard |

> **Требует подписку Pro, Max, Team или Enterprise** для custom connectors и Projects.

## Вариант 1: MCP Connector (рекомендуется)

### Подключить Createya MCP

1. Перейди в **Settings** (шестерёнка) → **Connectors**
2. Нажать **Add connector**
3. Вставить URL: `https://api.createya.ai/mcp`
4. Если появится OAuth экран — авторизоваться через Createya аккаунт
5. После подключения — connector появится в списке

### Использование в чате

После подключения инструменты `mcp__createya__*` доступны в чатах. Createya MCP сам управляет авторизацией через OAuth — API ключ вводить не нужно, всё через аккаунт.

```
Сгенерируй через Createya: жёлтое худи на манекене, белый фон, nano-banana-pro

Сделай UGC-видео для товара — женские кроссовки, 10 секунд, Telegram-стиль съёмки
```

## Вариант 2: Projects + Instructions (без MCP)

Если MCP недоступен или ты на Free-тире, используй Projects:

### Создать Project с инструкциями

1. Sidebar → **New project**
2. Название: "Creative Director"
3. В поле **Instructions** вставить:

```
You are a creative director specialized in AI media generation through Createya.ai API.

When the user asks to generate images, videos, or plan a photoshoot:

1. Interrogate if brief is incomplete: ask about subject, style, platform, format
2. Etalon first: generate one locked-composition reference frame
3. Approval gate: show result, wait for "ок" / "да" / "good" / approval before variations
4. Variations: image-to-image from approved etalon

## API (use curl/fetch or ask user to run)
Base URL: https://api.createya.ai/v1
Auth: Bearer token (ask user for CREATEYA_API_KEY)

List models: GET /v1/models
Get prompt guide: GET /v1/models/{slug}/prompting-guide
Generate: POST /v1/generate { model, prompt, parameters }
Poll status: GET /v1/runs/{run_id}/status

## Key models
- nano-banana-pro — photorealism, portraits, products (18 credits)
- flux-pro — versatile creative (8 credits)
- seedance-2.0-pro — video with audio (120 credits)
- veo3.1 — video, high quality (200 credits)

## Rules
- Always get prompting guide before generating (shows best practices per model)
- Prompt minimum 250 words in English for image models
- UGC needs: imperfection block (grain, off-center, handheld) + skin realism
- Two-step for video: image first → approved → animate
- Credit estimate before expensive models (>50 credits)
```

4. Прикрепить файлы — можно добавить SKILL.md из этого репозитория как knowledge base

### Прикрепить SKILL.md как документ

1. В Project → **Add content**
2. Загрузить файл `skills/creative-director/SKILL.md` (скачай из [GitHub](https://github.com/Createya-ai/createya-mcp/blob/main/skills/creative-director/SKILL.md))
3. Теперь все чаты в этом проекте будут использовать полный SKILL.md как контекст

Таким образом SKILL.md работает как instructions через Projects — не нативно, но близко к нативному поведению.

## Работа с медиа в web

### Загрузить референс

В web-чате нет прямого API для загрузки медиа через MCP. Варианты:

**Через Dashboard:**
```
Загрузи на https://createya.ai → Assets → Upload, потом дай мне CDN URL
```

**Через curl в терминале:**
1. Получи presigned URL через API или попроси агента выдать (если MCP подключён)
2. Загрузи файл: `curl -X PUT "PRESIGNED_URL" --data-binary @file.jpg`
3. Используй CDN URL в запросах

**Как вложение в чат:**
Прикрепи изображение к сообщению — Claude увидит его и сможет описать, но не сможет напрямую использовать как `referenceImages` для Createya. Это работает только как визуальный референс для написания промпта.

## Troubleshooting

**Connector не появляется в чатах:**
1. Settings → Connectors → проверь что connector включён (toggle ON)
2. В новом чате должен появиться значок инструментов

**403 при добавлении connector:**
Убедись что у тебя подписка Pro или выше. Free tier не поддерживает custom connectors.

**Projects instructions не применяются:**
Убедись что открываешь чат внутри Project (sidebar → выбрать project → New chat).

## Поддержка

- Issues: [github.com/Createya-ai/createya-mcp/issues](https://github.com/Createya-ai/createya-mcp/issues)
- Email: support@createya.ai
