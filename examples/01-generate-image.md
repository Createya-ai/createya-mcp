# Пример 1 — Генерация изображения

## Простой случай

**Запрос пользователя:**
> Сгенерируй картинку через Createya — кот в космическом скафандре, фотореалистично, 16:9.

**Что делает агент:**

```typescript
createya:run_model({
  model: "nano-banana-2",
  input: {
    prompt: "Cat in a space suit floating in cosmos, photorealistic, cinematic lighting",
    aspect_ratio: "16:9"
  }
})
```

**Ответ:**
```json
{
  "run_id": "run_01HZX...",
  "status": "completed",
  "output": {
    "urls": [
      "https://cdn-new.createya.ai/image/profile-id/abc123.png"
    ]
  }
}
```

## Image-to-image (изменение существующей картинки)

**Запрос:**
> Возьми эту картинку (https://example.com/cat.jpg) и сделай её в стиле Van Gogh.

```typescript
createya:run_model({
  model: "nano-banana-2",
  input: {
    prompt: "in the style of Van Gogh, oil painting, swirling brushstrokes",
    image_url: "https://example.com/cat.jpg"
  }
})
```

Сервер автоматически выберет `image-to-image` endpoint потому что в input есть `image_url`.

## Какие модели для каких задач

Полный актуальный список — на сайте: [createya.ai/knowledge](https://createya.ai/knowledge). Кратко по задачам:

| Задача | Где смотреть |
|---|---|
| Хорошая универсальная картинка | [Nano Banana 2](https://createya.ai/knowledge/nano-banana-2) |
| Топ фотореализм / лица | [FLUX 2](https://createya.ai/knowledge/flux-2), [Flux Kontext](https://createya.ai/knowledge/flux-kontext) |
| Кинематограф / стиль | [Higgsfield Soul](https://createya.ai/knowledge/higgsfield-soul), [Midjourney](https://createya.ai/knowledge/midjourney) |
| Photorealism + people | [Kling Image O3](https://createya.ai/knowledge/kling-image-o3) |
| Свежий xAI генератор | [Grok Imagine](https://createya.ai/knowledge/grok-imagine) |
| Модель OpenAI | [GPT Image 2.0](https://createya.ai/knowledge/gpt-image-2-0) |

Список параметров (`prompt`, `aspect_ratio`, `negative_prompt`, `seed`, и т.д.) для каждой модели:
```typescript
createya:list_models({ category: "image" })
// или
GET https://api.createya.ai/v1/models
```

## Ошибки и что делать

| Код | Причина | Решение |
|---|---|---|
| `402` | Не хватает кредитов | Пополнить на [createya.ai](https://createya.ai) |
| `422` | Неверный `prompt` (триггерит модерацию) | Перефразировать промпт |
| `500` | Внутренняя ошибка | Повторить через `run_model` или попробовать другую модель |
