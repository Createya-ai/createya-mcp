# UGC product selfie — AI инфлюенсер с товаром, phone aesthetic

AI-блогер демонстрирует товар через selfie / mirror shot / casual point-and-shoot. Главный принцип — это выглядит как контент из реальной жизни, снятый на телефон.

## Принцип
> "Красивая случайность, а не поставленная съёмка. Зритель должен думать 'она сама это снимала'."

ОБЯЗАТЕЛЬНО читать `ugc-realism.md` перед применением этой формулы. Без него выход будет "слишком студийным".

---

## Три формата UGC selfie

### Format 1 — Direct selfie (телефон вытянут к камере)

```
"Selfie POV: camera held at arm's length, slight upward angle (15-20° above eye-level),
natural selfie composition — face and product in same frame,
slight foreground blur at corner (hand/arm), authentic candid feel."
```

Типичные ошибки:
- Неестественный угол → указать конкретно "15 degrees above eye-level"
- Рука не видна → добавить "one hand visible holding phone at edge of frame"
- Слишком студийно → добавить camera imperfections block из `ugc-realism.md`

### Format 2 — Mirror selfie

```
"Mirror selfie: full or 3/4 body reflected in mirror, phone visible in hand,
mirror environment visible in background [bathroom / bedroom / fitting room],
authentic framing — not perfectly centered, slight tilt, casual composition."
```

Тип зеркала определяет mood:
- Bathroom vanity → skincare/beauty products
- Full-length bedroom → fashion/clothing
- Gym mirror → fitness/activewear
- Boutique fitting room → fashion try-on

### Format 3 — Point-and-shoot / over-shoulder

```
"Casual point-and-shoot aesthetic: camera held loosely, subject mid-action,
off-center framing, candid unposed quality, journalist-style capture."
```

---

## Character + Product reference stack

Порядок `reference_image_urls`:

```json
{
  "reference_image_urls": [
    "<character hero ref — from character-sheet.md>",
    "<product photo ref>",
    "<style/aesthetic ref optional>"
  ]
}
```

Никогда не ставить product ref первым — identity drift.

---

## Environments по типу товара

| Товар | Окружение | Детали |
|-------|---------|--------|
| Косметика / skincare | Bathroom, vanity | "white marble counter, ring light reflection visible, morning light" |
| Одежда / fashion | Bedroom mirror / fitting room | "natural light from window, rumpled bed in background, casual bedroom" |
| Fitness supplement | Gym / post-workout | "gym equipment in background, slight sweat, athletic wear" |
| Food / напитки | Kitchen / cafe | "kitchen counter, morning light, coffee items nearby" |
| Tech gadgets | Desk / bedroom | "casual home environment, couch or desk, laptop visible" |
| Beauty tools | Bathroom / vanity | "bright bathroom, steamy mirror optional, hair styling context" |

---

## Полный prompt template (270+ слов)

```
[CHARACTER — 3-4 sentences from character sheet verbatim]

[CHARACTER] is taking a [selfie / mirror selfie / casual shot] featuring [PRODUCT].
[Product description: name, color, what it is].
[How product appears: "holding [product] up next to face" / "wearing [product]" /
"product visible in foreground, character in background"].

[FORMAT-SPECIFIC framing from options above — 2-3 sentences].

Environment: [description 3 sentences — specific location, surfaces, background elements,
ambient items that reinforce authentic use context].

Lighting: [from ugc-realism.md lighting options]:
["soft ring light from phone flashlight" / "natural window light from left" /
"overhead bathroom vanity light, warm" / "gym fluorescent overhead"].

[CAMERA IMPERFECTIONS BLOCK — mandatory, from ugc-realism.md]:
Camera imperfections: handheld iPhone aesthetic, slight motion blur on edges,
off-center framing, occasional soft focus, slight overexposure on highlights,
subtle lens distortion at frame edges, small grain in shadows, candid unposed feel.

[SKIN REALISM BLOCK — mandatory, from ugc-realism.md]:
Skin: visible pores, slight unevenness in skin tone, minor undereye shadows,
hint of natural shine, faint expression lines.
No: acne, blemishes, pimples.

Expression: [candid genuine from ugc-realism: mid-laugh / caught looking / 
slight smile / excited about product / approving nod].

Style: authentic UGC creator content, iPhone aesthetic, social media post quality.
Quality: photorealistic, high detail, natural skin texture.

Negative: studio quality, professional lighting setup, posed expression, symmetric composition,
fashion editorial feel, too perfect, no text, no watermark, no subtitles.
```

---

## Lighting options для UGC

| Ситуация | Prompt phrase |
|----------|--------------|
| Утренний bathroom | "soft warm bathroom vanity light, slight warm glow, natural morning quality" |
| Дневной natural | "bright natural daylight from nearby window, clean and fresh" |
| Ring light (creator) | "ring light from phone or small ring light, slight catchlight ring in eyes" |
| Gym | "overhead fluorescent gym lighting, bright and slightly harsh" |
| Outdoor golden | "warm afternoon golden hour, directional soft sunlight" |

---

## Polished vs. Raw: dial

| Настройка | Raw authentic | Polished influencer |
|-----------|--------------|---------------------|
| Composition | Off-center, sloppy | Thoughtfully casual |
| Lighting | Whatever's available | Optimized natural |
| Expression | Caught mid-moment | Curated candid |
| Environment | Messy real | Clean but lived-in |
| Camera imperfections | Full block | Subtle only |

Raw → "authentic ugc, raw real life moment"
Polished → "polished lifestyle influencer content, curated authentic feel"

---

## Cross-references

- ОБЯЗАТЕЛЬНО: `ugc-realism.md` — camera imperfections + skin realism блоки
- Character creation: `character-sheet.md`
- Real influencer: `influencer-recreation.md`
- UGC video: `ugc-video.md`
- Lighting natural: `references/presets/lighting/natural-window.md`, `ring-light.md`
- Style: `references/presets/style/ugc-raw-authentic.md`, `ugc-polished-influencer.md`
