# Пример 2 — Генерация видео

## Сценарий: оживить картинку (image-to-video)

**Запрос пользователя:**
> Возьми эту картинку (https://example.com/landscape.jpg) и оживи через Kling, 5 секунд.

**Шаг 1 — запуск (async):**

```typescript
createya:run_model({
  model: "kling-video-o3",
  input: {
    image_url: "https://example.com/landscape.jpg",
    prompt: "wind blowing through trees, clouds moving slowly, cinematic",
    duration: 5
  }
})
```

**Ответ:**
```json
{
  "run_id": "run_01J2ABCDEF...",
  "status": "queued"
}
```

**Шаг 2 — polling:**

```typescript
createya:get_run_status({ run_id: "run_01J2ABCDEF..." })
```

Через некоторое время:
```json
{
  "run_id": "run_01J2ABCDEF...",
  "status": "completed",
  "output": {
    "url": "https://cdn-new.createya.ai/video/profile-id/xyz789.mp4"
  }
}
```

> 💡 Polling совет: первый раз через 20 сек, потом каждые 10 сек.

## first-last-frame (видео из 2 ключевых кадров)

```typescript
createya:run_model({
  model: "kling-video-o3",
  input: {
    start_image_url: "https://example.com/start.jpg",
    end_image_url: "https://example.com/end.jpg",
    prompt: "smooth transition between scenes",
    duration: 5
  }
})
```

Сервер автоматически выберет endpoint `first-last-frame` потому что в input есть и `start_image_url`, и `end_image_url`.

## Какие модели для какого видео

Полный актуальный список — [createya.ai/knowledge](https://createya.ai/knowledge):

| Задача | Где смотреть |
|---|---|
| OpenAI flagship | [Sora 2](https://createya.ai/knowledge/sora-2) |
| Google flagship | [Veo 3.1 / Veo 3.1 Fast](https://createya.ai/knowledge/veo) |
| Kling в разных версиях | [O3](https://createya.ai/knowledge/kling-video-o3) / [V3](https://createya.ai/knowledge/kling-video-v3) / [4K](https://createya.ai/knowledge/kling-video-4k) |
| ByteDance Seedance | [Seedance 2.0](https://createya.ai/knowledge/seedance-2-0) / [1.5](https://createya.ai/knowledge/seedance) |
| Реалистичные сцены | [Happy Horse 1.0](https://createya.ai/knowledge/happy-horse) |

Параметры каждой модели — через `createya:list_models({ category: "video" })` или `GET /v1/models`.

## Ошибки

| Код | Причина | Решение |
|---|---|---|
| `408` | Async таймаут | Попробуй другую модель |
| `402` | Не хватает кредитов | Пополнить на [createya.ai](https://createya.ai) |
| `429` | Rate limit | Подожди, повтори |

## Best practices

1. **Сначала картинка → потом анимация.** Сгенерируй image (например через `nano-banana-2`), потом оживи через `kling-video-o3`. Дешевле и контроль выше.
2. **Используй `first-last-frame` для контролируемых переходов** — кадры в начале и в конце, модель сама строит middle.
3. **Промпт описывает движение, не только сцену.** Видео-модели слушают глаголы: "moving", "swaying", "flowing", "rotating slowly".
4. **Начинай с 5 секунд.** Длиннее = дороже + чаще artifact'ы.
