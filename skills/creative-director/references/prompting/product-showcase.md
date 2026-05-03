# Product showcase — товар + AI человек

Двухшаговый workflow: статичный кадр с утверждением → видео. Человек демонстрирует товар в реальном контексте использования.

## Принцип
> "Контекст использования важнее красивого фона. Покупатель должен представить себя с товаром."

## Two-step workflow

```
Step 1: Still (Nano Banana / Flux) → user approves
Step 2: Video (Veo 3.1 / Seedance / Kling) с approved still как startFrame
```

Шаг 2 — только после явного approval шага 1. Никогда параллельно.

---

## Step 1 — Still prompt formula (250+ слов)

### Компоненты промта

**1. Character (from character-sheet.md)**
```
[Subject verbatim from character _vision.md: 3-4 sentences — appearance, distinctive features]
```

**2. Product**
```
[Product name and type]: [detailed description — material, color, size/form factor,
key visual features, brand markers if any].
[How it looks in this specific interaction — scale relative to person]
```

**3. Interaction style (выбрать один)**

| Стиль | Промт-фраза | Use case |
|-------|------------|---------|
| Holding casually | "holding [product] naturally in [hand], relaxed casual grip, product clearly visible" | Lifestyle товары |
| About to use | "in the moment just before using [product], hand positioned, anticipatory expression" | Food, beauty, tech |
| Mid-use | "actively using [product] in natural motion, engaged, product in clear view" | Fitness, kitchen, tools |
| Displaying | "holding [product] up slightly toward camera, subtle presentation gesture, genuine expression" | Unboxing, gift |
| Integrated | "[product] naturally part of scene — on nearby surface, being picked up / set down" | Home goods, decor |

**4. Environment по use case**

| Товар | Окружение |
|-------|---------|
| Косметика / beauty | Bathroom vanity, natural window light, marble/wood surface |
| Еда / напитки | Kitchen counter or cafe table, warm light, minimal props |
| Fitness / спорт | Gym space, sports venue, outdoor path |
| Tech / gadgets | Modern home office desk, clean minimal setup |
| Fashion / одежда | Lifestyle indoor (apartment) or urban outdoor |
| Home goods | Living room, kitchen, bedroom — matching interior style |
| Gift / unboxing | Neutral clean surface, warm light |

**5. Lighting**
```
[Lighting appropriate to environment from table above]
```

**6. Camera**
```
Camera: Sony A7R IV, [50-85mm], f/[2.8-4], focus on person-product interaction.
```

### Полный шаблон

```
[CHARACTER — 3-4 sentences verbatim from character sheet]

[CHARACTER] is [interaction style] [PRODUCT DESCRIPTION].
[Product detail: color/material clear in frame, label/branding visible if relevant].
[Interaction specifics: which hand, arm position, product orientation].

Environment: [environment description 3 sentences —
             setting, surface/furniture, background depth, ambient elements].

[LIGHTING — 2-3 sentences].

Camera: Sony A7R IV, [focal length], f/[aperture].
Focus: sharp on person-product interaction point, natural depth of field.

[Style markers for mood: "warm lifestyle feel" / "editorial cool" / "authentic candid"].
Quality: professional lifestyle photography, photorealistic, high detail, 8K.

Negative: product partially hidden, awkward grip, unnatural pose, distorted hands,
wrong product scale, no text, no watermark.
```

---

## Step 2 — Video prompt formula

### Pre-flight

- Approved still → загружен → URL получен
- `start_frame_image_url` = approved still URL
- Длительность: 5-8 секунд (оптимально для showcase)

### Video action по interaction style

| Still interaction | Video action |
|-------------------|-------------|
| Holding casually | Slight arm movement, natural weight shift, product stays visible |
| About to use | Complete the action — открыть, попробовать, надеть |
| Mid-use | Continue action, 3-5 секунд действия |
| Displaying | Slight turn of product, small gesture, genuine reaction |
| Integrated | Pick up / set down / reach for product |

### Video prompt template

```
Continuing from the still image: [CHARACTER] [ACTION — 2-3 sentences describing
the movement that flows naturally from the approved still frame].

Natural movement qualities: slight weight shifts, natural breathing,
genuine micro-expressions, authentic interaction with [PRODUCT].

[PRODUCT] remains clearly visible throughout, in focus, [specific visibility note].

Camera: [handheld subtle / smooth dolly / static hold] — slight natural movement.
No abrupt cuts. Seamless continuation from start frame.

Audio: [ambient room tone / subtle environment sound — NOT voice unless scripted].

Quality: smooth motion, photorealistic, consistent with reference frame.

Negative: sudden jump from start frame, different person, different product,
no frozen mannequin effect, no jerky movement, no subtitles, no captions.
```

### Если нужен dialogue / voice

Скрипт диалога — ОТДЕЛЬНЫЙ блок, читается вслух юзером перед апрувом:

```json
{
  "spoken_text": "[exact words character will say]",
  "duration_sec": "[word count / 2.5 = approx duration]",
  "tone": "conversational / enthusiastic / informative"
}
```

Approval от юзера на скрипт → только потом генерировать с audio enabled.

---

## Reference hierarchy для generation

```json
{
  "reference_image_urls": [
    "<character hero ref from character-sheet>",
    "<product photo ref>",
    "<style/environment ref optional>"
  ],
  "start_frame_image_url": "<approved still — only for video step>",
  "model_slug": "nano-banana-pro"
}
```

---

## Cross-references

- Character создание: `character-sheet.md`
- Real influencer вместо AI: `influencer-recreation.md`
- Product без человека: `product-hero.md`
- UGC стиль (selfie format): `ugc-product-selfie.md`
- Video UGC отзыв: `ugc-video.md`
