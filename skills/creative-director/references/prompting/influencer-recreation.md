# Influencer recreation — воссоздание реального человека

Workflow для генерации контента с конкретным человеком по 1-3 фото референсам. Подходит для: AI-версии реального инфлюенсера, персонализированного контента, бренд-амбассадора.

## Принцип
> "Ref image — всегда приоритет. Промт описывает черты, ref их закрепляет. Без ref — получишь похожего, не его."

Two-step: still image approval → video (если нужно).

## Требования к референс-фото

Идеальный ref пакет:
1. **Hero ref** — frontal, хорошее освещение, лицо чётко видно, нейтральное выражение
2. **Secondary ref** — 3/4 угол, то же лицо
3. **Style ref** — optional, задаёт нужный mood/outfit

Минимум: 1 фото (frontal). Качество > количество. Плохое размытое фото хуже отсутствия.

`reference_image_urls: [hero_ref_url, secondary_ref_url]` — в таком порядке.

## Identity preservation — двойная стратегия

### 1. Ref images (главное)
Всегда передавать как `reference_image_urls`. Это закрепляет 70% визуальной идентичности.

### 2. Prompt identity anchor (обязательно)
В subject block прописать 3-4 ключевых черты буквально:

```
[eye color: deep brown/piercing green/etc], [specific hair: long wavy dark brown / short platinum blonde / etc],
[distinctive feature: sharp cheekbones / strong brow / defined jawline / unique birthmark],
[skin tone: warm olive / fair porcelain / deep mahogany]
```

Это предотвращает mode collapse при сложных сценах.

## Структура промта (250+ слов)

```
[CHARACTER IDENTITY — 4-5 sentences]:
<person name if public figure, or "the subject"> is a <age range> <ethnicity/look> <gender>.
Distinctive features: [eye color], [hair description], [face shape], [key feature].
[Skin tone, texture]. [Energy/vibe — confident professional, warm approachable, edgy creative].
This is the same person as shown in the reference images — maintain exact facial features,
eye color, and hair color from the reference.

[CLOTHING — 3-4 sentences if specific outfit needed]:
<describe fully or leave open for model freedom>

[SCENE/ACTION — 3-4 sentences]:
<pose, environment, action>

[LIGHTING — 2 sentences]
[CAMERA — 2 sentences: brand, focal length, aperture]

Style: <mood markers>
Quality: professional photography, high detail, photorealistic, 8K.

Negative: different person, altered facial features, changed eye color, changed hair color,
different bone structure, aging effects, beautification filters, no text, no watermark.
```

## Anti-mode collapse приёмы

Если после нескольких вариаций лицо "уплывает":

| Симптом | Решение |
|---------|---------|
| Лицо стало другим | Добавить ещё один ref + усилить identity anchor в промте |
| Цвет волос меняется | Прямо прописать: "hair color EXACTLY as in reference: [color]" |
| Возраст сдвинулся | Указать точный age range: "appears approximately 28-32 years old" |
| Типаж изменился | Добавить "same person as reference, do not alter facial structure" |
| Стало "красивее" | Добавить "no beautification, no idealization, natural appearance" |

## Ratio reference-to-prompt importance

Для identity preservation:
- `reference_weight: 0.7-0.8` — если модель поддерживает параметр
- Если нет параметра — приоритет ref over artistic freedom в промте указать явно:
  > "Reference images take priority over any stylistic interpretation. Maintain exact identity."

## Two-step: still → video

### Step 1: Still с approval gate

Генерировать 2-3 варианта still. Approval от юзера обязателен перед Step 2.

### Step 2: Video (Veo 3.1 / Kling / Sora)

Still → `start_frame_image_url` для video модели.

Дополнительные video cues:
- Natural micro-expressions: "subtle eye blinks, slight head nod, natural breathing movement"
- Не "frozen" — указать конкретное действие (speaking, turning head slightly, walking)

```json
{
  "model_slug": "veo-3-1",
  "start_frame_image_url": "<approved still cdn url>",
  "reference_image_urls": ["<hero ref url>"],
  "duration": 5,
  "prompt": "<full video prompt>"
}
```

## Сохранение

```
creative/assets/models/<person-slug>/
├── _ref-hero.jpg        ← оригинальный референс юзера
├── _ref-secondary.jpg   ← если был
├── _vision.md
└── <generated outputs по датам>
```

## Этические ограничения

Skill не генерирует:
- Реальных людей в дискредитирующих или сексуализированных сценах
- Deep fake контент без согласия
- Контент, имитирующий чужую идентичность для обмана

Для бренд-амбассадора с реальным человеком — убедиться что юзер имеет права на использование образа.

## Cross-references

- Для recurring AI-персонажа без реального прообраза: `character-sheet.md`
- UGC видео с персонажем: `ugc-video.md`
- Character в product showcase: `product-showcase.md`
