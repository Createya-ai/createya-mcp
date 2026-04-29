# 🎬 Video-модели Createya

> Этот файл синхронизируется автоматически раз в неделю с [createya.ai/v1/models](https://api.createya.ai/v1/models).
> Последнее обновление: 2026-04-29

Полный каталог с интерактивными примерами и подробным описанием — на сайте: [**createya.ai/knowledge**](https://createya.ai/knowledge).

---

## Опубликованные модели

| Модель | Слоган | Подробнее |
|---|---|---|
| **Sora 2** | Imagine. Describe. Watch. | [createya.ai/knowledge/sora-2](https://createya.ai/knowledge/sora-2) |
| **Veo 3.1** | Think Film. Generate Film. | [createya.ai/knowledge/veo](https://createya.ai/knowledge/veo) |
| **Veo 3.1 Fast** | Same Vision. Five Times Faster. | [createya.ai/knowledge/veo-fast](https://createya.ai/knowledge/veo-fast) |
| **Kling Video O3** | Reference. Clone. Direct. | [createya.ai/knowledge/kling-video-o3](https://createya.ai/knowledge/kling-video-o3) |
| **Kling Video V3** | Direct. Cut. Create. | [createya.ai/knowledge/kling-video-v3](https://createya.ai/knowledge/kling-video-v3) |
| **Kling VIDEO 4K** | Кино-качество в каждом кадре | [createya.ai/knowledge/kling-video-4k](https://createya.ai/knowledge/kling-video-4k) |
| **Seedance 2.0** | Кино из одного промпта — звук, кадры, движение | [createya.ai/knowledge/seedance-2-0](https://createya.ai/knowledge/seedance-2-0) |
| **Seedance 1.5** | Move. Dance. Create. | [createya.ai/knowledge/seedance](https://createya.ai/knowledge/seedance) |
| **Happy Horse 1.0** | Видео №1 в мире. Со звуком. За 10 секунд. | [createya.ai/knowledge/happy-horse](https://createya.ai/knowledge/happy-horse) |

---

## Дополнительно доступны через API

Доступны через `run_model` / `POST /v1/run` (без выделенной KB-страницы — параметры через `list_models` / `GET /v1/models`):

- Higgsfield Video, Grok Video, Minimax, Wan, Sync Lipsync V3, Infinitetalk, Midjourney Video

---

## Режимы генерации

Большинство видео-моделей поддерживают несколько режимов — сервер выбирает endpoint автоматически по содержимому `input`:

| `input` содержит | Будет выбран режим |
|---|---|
| Только `prompt` | `text-to-video` |
| `image_url` | `image-to-video` |
| `start_image_url` + `end_image_url` | `first-last-frame` |
| `video_url` | `video-to-video` (если поддерживается) |

---

## Как использовать

### Через MCP (async)

```typescript
// Шаг 1 — запуск
const run = await createya:run_model({
  model: "kling-video-o3",
  input: {
    image_url: "https://example.com/photo.jpg",
    prompt: "smooth fur motion, eyes blinking, cinematic",
    duration: 5
  }
});
// → { run_id: "run_01J2...", status: "queued" }

// Шаг 2 — polling
const status = await createya:get_run_status({ run_id: run.run_id });
// → { status: "completed", output: { url: "https://cdn-new.createya.ai/video/..." } }
```

### Через REST

```bash
# Запуск
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kling-video-o3",
    "input": {
      "image_url": "https://example.com/photo.jpg",
      "prompt": "smooth fur motion",
      "duration": 5
    }
  }'
# → { "run_id": "run_01J2...", "status": "queued" }

# Polling каждые 10 сек
curl https://api.createya.ai/v1/runs/run_01J2... \
  -H "Authorization: Bearer crya_sk_live_..."
```

Полный каталог с актуальными slug'ами и параметрами:
```bash
curl https://api.createya.ai/v1/models | jq '.[] | select(.output_type == "video")'
```

### Best practices

1. **Сначала картинка → потом анимация.** Сгенерируй image (например `nano-banana-2`), потом оживи через `kling-video-o3`. Дешевле, контроль выше, лучше результат.
2. **Используй `first-last-frame` для контролируемых переходов** — кадры начала и конца, модель сама строит middle.
3. **Промпт описывает движение, не только сцену.** Видео-модели слушают глаголы: "moving", "swaying", "flowing", "rotating slowly".
4. **Начинай с 5 секунд.** Длиннее = больше времени и кредитов + чаще artifact'ы.
