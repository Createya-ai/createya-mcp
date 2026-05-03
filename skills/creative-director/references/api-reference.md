# API Reference (Createya Gateway)

Краткая шпаргалка endpoints + MCP tools которые использует skill.

> Полная документация: https://createya.ai/api  
> OpenAPI спека: https://api.createya.ai/v1/openapi.json

## Auth

Все запросы требуют API ключ:
```
Authorization: Bearer crya_sk_live_<32hex>
```

Ключи привязаны к workspace — кредиты списываются с `workspaces.credits_balance`.

## Окружения

| Env | Public URL |
|---|---|
| **PROD** (default) | `https://api.createya.ai` |
| **DEV** | `https://api-dev.createya.ai` |

В bash скриптах: `${CREATEYA_API_BASE:-https://api.createya.ai}`.

## REST endpoints (через bash)

### `GET /v1/me`
Профиль + workspace.
```bash
curl -H "Authorization: Bearer $CREATEYA_API_KEY" $BASE/v1/me
```

### `GET /v1/models`
Каталог. Без auth → public; с auth → public + test endpoints.

### `POST /v1/run`
Запуск генерации (используй MCP `run_model` вместо этого где возможно).
```bash
curl -X POST $BASE/v1/run \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"nano-banana-pro","input":{"prompt":"..."}}'
```

### `GET /v1/runs/{id}`
Статус async-генерации.

### `GET /v1/balance`
Баланс кредитов.

### `POST /v1/uploads/presigned`
**Главный endpoint для skill'а** — получить presigned PUT URL.

```bash
curl -X POST $BASE/v1/uploads/presigned \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "filename": "front.jpg",
    "mime_type": "image/jpeg",
    "size_bytes": 245678,
    "folder_path": "products/yellow-hoodie"
  }'
```

Response:
```json
{
  "object": "upload_presigned",
  "presigned_url": "https://storage.yandexcloud.net/...",
  "cdn_url": "https://cdn-new.createya.ai/temp/<user>/<...>.jpg",
  "method": "PUT",
  "headers": { "Content-Type": "image/jpeg" },
  "expires_at": "2026-05-03T18:40:00Z",
  "will_delete_at": "2026-05-04T18:30:00Z",
  "max_size_bytes": 52428800
}
```

Затем `PUT` raw bytes на `presigned_url` с заголовком `Content-Type`. Файл живёт 24 часа в S3, потом auto-delete через bucket lifecycle.

**Лимиты**:
- Max size: 50 MB
- TTL по умолчанию: 24 часа (можно до 7 дней через `ttl_hours`)
- Allowed mime: `image/{jpeg,png,webp,gif,heic,heif}`, `video/{mp4,quicktime,webm}`, `audio/{mpeg,wav,ogg,mp4}`

## MCP tools

Skill всегда предпочитает MCP (если доступен) над прямыми REST вызовами.

### `mcp__createya__list_models`
Каталог семейств с `parameters_schema`. Зови первым.

### `mcp__createya__run_model`
```typescript
mcp__createya__run_model({
  model: "nano-banana-pro",        // family slug
  input: {
    prompt: "...",
    image_url: "https://cdn-new.createya.ai/...",
    aspect_ratio: "1:1"
    // параметры из parameters_schema
  }
})
```

Возвращает `{ id, status, output: { urls: [...] }, credits_used }`.

### `mcp__createya__get_run_status`
Polling для async моделей (видео).

### `mcp__createya__get_balance`
Баланс workspace.

### `mcp__createya__request_upload_url`
То же что REST `/v1/uploads/presigned`, но через MCP. Используй когда bash недоступен.

## Family vs endpoint slug

В `run_model` можно передать **family slug** (`nano-banana-pro`, `kling-video-o3-pro`) — сервер сам выберет endpoint по содержимому `input`:

| Input | → Endpoint |
|---|---|
| только `prompt` | text-to-* |
| `image_url` / `input_images[]` | image-to-* / -edit |
| `start_image_url` + `end_image_url` | first-last-frame |
| `video_url` / `input_video` | video-to-* |

Прямой endpoint slug тоже принимается — берётся как есть без скоринга.

## Ошибки

| Code | Что значит |
|---|---|
| **401** | Неверный/истёкший API ключ → проверь .env |
| **402** | Insufficient credits → пополнить https://createya.ai |
| **404** | Wrong slug → `list_models` для проверки |
| **413** | Payload too large → файл >50MB |
| **422** | Validation/moderation → читай `error.message` |
| **500** | Upstream / infra issue → retry, при повторе сообщи юзеру |

## Pricing reference (на момент 2026-05)

| Model family | credits/req | sync/async | output |
|---|---|---|---|
| `nano-banana-pro` | 18 | sync | image |
| `flux-2` | ~25 | sync | image |
| `seedance-2-0` | 60-120 (зависит от duration) | async | video |
| `veo3.1` | ~150 (8s @ 720p) | async | video |
| `sora-2` | ~200 (12s) | async | video |
| `kling-video-o3-pro` | ~80-150 | async | video |

Точная стоимость — `mcp__createya__list_models` на момент сессии. Для уже сделанных генераций — `logs/createya-api.jsonl`.

## Security checklist

- [x] `.env` в `.gitignore`
- [x] Никогда не печатай ключ в чат / commit / log
- [x] Presigned URLs привязаны к user_id из ключа — невозможно подставить чужой prefix
- [x] Загруженные файлы автоматически удаляются через 24h (никакого ручного cleanup'а)
- [x] User не имеет direct S3 доступа — только через наши endpoints
