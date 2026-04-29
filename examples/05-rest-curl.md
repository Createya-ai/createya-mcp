# Пример 5 — REST API через curl (без MCP)

Если не хочешь возиться с MCP — просто curl с Bearer-токеном.

## 1. Получить токен

1. Зарегистрируйся на [createya.ai](https://createya.ai) → 100 бесплатных кредитов
2. [createya.ai/settings/api-keys](https://createya.ai/settings/api-keys) → **Create new key** → скопируй
3. Формат: `crya_sk_live_<32hex>`. Сохрани в env var:
   ```bash
   export CREATEYA_API_KEY="crya_sk_live_..."
   ```

## 2. Простая sync-генерация (картинка)

```bash
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "nano-banana-2",
    "input": {
      "prompt": "кот на луне в стиле Studio Ghibli",
      "aspect_ratio": "16:9"
    }
  }' | jq .
```

**Ответ:**
```json
{
  "run_id": "run_01HZX...",
  "status": "completed",
  "output": {
    "urls": ["https://cdn-new.createya.ai/image/profile-id/abc123.png"]
  }
}
```

## 3. Async-генерация (видео)

### Запуск
```bash
RESPONSE=$(curl -s -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kling-video-o3",
    "input": {
      "image_url": "https://example.com/cat.jpg",
      "prompt": "wind blowing through fur, eyes blinking",
      "duration": 5
    }
  }')

RUN_ID=$(echo $RESPONSE | jq -r .run_id)
echo "Started: $RUN_ID"
```

### Polling
```bash
while true; do
  STATUS=$(curl -s https://api.createya.ai/v1/runs/$RUN_ID \
    -H "Authorization: Bearer $CREATEYA_API_KEY" | jq -r .status)

  echo "Status: $STATUS"

  if [ "$STATUS" = "completed" ] || [ "$STATUS" = "failed" ]; then
    break
  fi
  sleep 10
done

# Финальный output
curl -s https://api.createya.ai/v1/runs/$RUN_ID \
  -H "Authorization: Bearer $CREATEYA_API_KEY" | jq .output
```

## 4. Image-to-image (загрузить свою картинку)

Если у тебя картинка локально — сначала залей в наш CDN:

```bash
# Загрузка
UPLOAD=$(curl -s -X POST https://api.createya.ai/v1/uploads \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: image/jpeg" \
  --data-binary @./my-cat.jpg)

IMAGE_URL=$(echo $UPLOAD | jq -r .url)
echo "Uploaded: $IMAGE_URL"

# Использование
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"nano-banana-2\",
    \"input\": {
      \"prompt\": \"in the style of Van Gogh\",
      \"image_url\": \"$IMAGE_URL\"
    }
  }" | jq .
```

## 5. Получить каталог моделей

```bash
curl https://api.createya.ai/v1/models \
  -H "Authorization: Bearer $CREATEYA_API_KEY" | jq '.[] | { id, family, output_type, credits_per_request }'
```

## 6. Проверить баланс

```bash
curl https://api.createya.ai/v1/balance \
  -H "Authorization: Bearer $CREATEYA_API_KEY" | jq .
```

## Коды ошибок

| Код | Что означает | Что делать |
|---|---|---|
| `200` | OK | Работает |
| `202` | Accepted (async задача создана) | Polling через `/v1/runs/{id}` |
| `400` | Bad request | Проверь body — возможно неверный JSON |
| `401` | Unauthorized | Ключ невалиден / истёк / не `crya_sk_live_*` |
| `402` | Insufficient credits | Пополни на [createya.ai](https://createya.ai) |
| `404` | Model not found | Проверь slug через `/v1/models` |
| `422` | Invalid input | Проверь `parameters_schema` модели |
| `429` | Rate limit | Подожди, потом повтори |
| `500` | Internal | Повтори через 10 сек |

## Полная документация

- [docs/api/getting-started.md в основном репо](https://createya.ai/api/getting-started)
- [REST API reference](https://createya.ai/api/rest)
- [OpenAPI 3.1 spec](https://api.createya.ai/v1/openapi.json)
