# 🖼 Image-модели Createya

> Этот файл синхронизируется автоматически раз в неделю с [createya.ai/v1/models](https://api.createya.ai/v1/models).
> Последнее обновление: 2026-04-29

Полный каталог с интерактивными примерами и подробным описанием — на сайте: [**createya.ai/knowledge**](https://createya.ai/knowledge).

---

## Опубликованные модели

| Модель | Слоган | Подробнее |
|---|---|---|
| **GPT Image 2.0** | Первая AI, которая думает перед тем как нарисовать | [createya.ai/knowledge/gpt-image-2-0](https://createya.ai/knowledge/gpt-image-2-0) |
| **Nano Banana 2** | Faster. Sharper. Smarter. | [createya.ai/knowledge/nano-banana-2](https://createya.ai/knowledge/nano-banana-2) |
| **FLUX 2** | See More. Create Better. | [createya.ai/knowledge/flux-2](https://createya.ai/knowledge/flux-2) |
| **Flux Kontext** | Edit. Refine. Perfect. | [createya.ai/knowledge/flux-kontext](https://createya.ai/knowledge/flux-kontext) |
| **Kling Image O3** | Think. Compose. Create. | [createya.ai/knowledge/kling-image-o3](https://createya.ai/knowledge/kling-image-o3) |
| **Higgsfield Soul** | Shot, Not Generated. | [createya.ai/knowledge/higgsfield-soul](https://createya.ai/knowledge/higgsfield-soul) |
| **Midjourney** | Art Beyond Imagination. | [createya.ai/knowledge/midjourney](https://createya.ai/knowledge/midjourney) |
| **GPT Image** | Say It. See It. | [createya.ai/knowledge/gpt-image](https://createya.ai/knowledge/gpt-image) |
| **Grok Imagine** | Imagine Without Limits. | [createya.ai/knowledge/grok-imagine](https://createya.ai/knowledge/grok-imagine) |
| **Runway Gen-4** | From Still to Motion. | [createya.ai/knowledge/runway-gen4](https://createya.ai/knowledge/runway-gen4) |

---

## Дополнительно доступны через API

Доступны через `run_model` / `POST /v1/run` (без выделенной KB-страницы — параметры через `list_models` / `GET /v1/models`):

- Ideogram, Imagen, Recraft, Seedream, Wan, Z-Image, Topaz (upscaler), Извлечь кадр (frame extraction)

---

## Как использовать

### Через MCP
```
createya:run_model({
  model: "<family-slug>",
  input: {
    prompt: "your prompt",
    aspect_ratio: "16:9"
  }
})
```

Семейные slug'и видны в `createya:list_models({ category: "image" })`.

### Через REST
```bash
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{"model":"<family-slug>","input":{"prompt":"your prompt"}}'
```

Полный каталог с актуальными slug'ами и параметрами:
```bash
curl https://api.createya.ai/v1/models | jq '.[] | select(.output_type == "image")'
```

### Image-to-image

Любая image-модель поддерживает image-to-image — добавь `image_url` в input:

```json
{
  "model": "nano-banana-2",
  "input": {
    "prompt": "in the style of Van Gogh",
    "image_url": "https://example.com/photo.jpg"
  }
}
```

Сервер автоматически выберет endpoint `image-to-image` потому что в input есть `image_url`.
