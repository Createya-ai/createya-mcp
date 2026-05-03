# Character sheet — 9-ракурсный референс для AI-модели

Обязательный workflow при создании recurring AI-инфлюенсера или бренд-персонажа. Без character sheet — identity drift между сессиями.

## Принцип
> "Hero portrait — закон. Остальные 8 ракурсов — следствия. Никогда не генерировать 9 углов одновременно."

Two-pass workflow. Сначала получить approved hero — потом генерировать остальные с hero как reference.

## Pass 1 — Hero portrait

### Формула hero промта (200+ слов)

```
[Full-face portrait, frontal view, eye-level]

Character description (4-5 sentences):
<age range, ethnicity/look, face shape, most distinctive features: eyes, cheekbones, jawline>
<hair: length, texture, color, style, how it falls>
<skin: tone, texture, glow/matte, any distinctive marks if intended>
<expression: neutral-but-warm, confident gaze, relaxed jaw>
<overall energy/vibe: what this person feels like>

Lighting: soft diffused studio light, slight three-point setup, minimal shadows on face,
catchlights in eyes, clean skin tones.

Camera: Sony A7R IV, 85mm f/2.8, sharp focus on eyes, shallow depth of field,
background pure white or very light neutral grey.

Style: professional headshot quality, natural no-makeup-makeup look,
no dramatic styling — this is the baseline reference.

Quality: professional photography, high detail skin texture, realistic,
8K resolution, photorealistic.

Negative: no text, no watermark, no extra fingers, no distorted face,
no extreme makeup, no artistic filters, no motion blur.
```

### Approval gate Pass 1

Skill показывает hero portrait и явно спрашивает:
- "Утверждаешь героя? Или корректируем перед Pass 2?"
- Указать проблему → правка промта → регенерация

**Pass 2 запускается ТОЛЬКО после "утверждаю" / "approved" / "ок".**

## Pass 2 — 8 дополнительных ракурсов

Все 8 промтов используют ОДИН шаблон: subject copy из hero + NEW framing/angle.

`reference_image_urls: [hero_cdn_url]` — обязательно для каждого.

### Полный список 9 ракурсов

| # | Slug | Framing | Camera | Угол |
|---|------|---------|--------|------|
| 1 | `hero-front` | Face+chest, tight crop | 85mm f/2.8 | Frontal eye-level |
| 2 | `three-quarter-left` | Face+shoulders | 85mm f/2.8 | 45° left of center |
| 3 | `three-quarter-right` | Face+shoulders | 85mm f/2.8 | 45° right of center |
| 4 | `profile-left` | Pure side view, face | 85mm f/4 | 90° left |
| 5 | `profile-right` | Pure side view, face | 85mm f/4 | 90° right |
| 6 | `face-closeup` | Eyes nose lips, extreme tight | 100mm f/2.8 | Frontal slight up |
| 7 | `medium-portrait` | Waist-up, neutral pose | 85mm f/4 | Frontal eye-level |
| 8 | `full-body-three-quarter` | Full body 3/4 left turn | 50mm f/5.6 | Eye-level full body |
| 9 | `above-angle` | Top-down 30°, face visible | 50mm f/4 | 30° above eye-level |

### Шаблон промта для Pass 2

```
[SUBJECT VERBATIM from hero: 4-5 sentences — copy exactly]

[ANGLE-SPECIFIC FRAMING — 2 sentences]:
<exact framing description from table above>
<head/body position specific to this angle>

Lighting: [copy from hero OR adjust for angle]
Camera: [see table for focal length and aperture]
Background: pure white seamless or very light neutral grey.

Style: same as hero reference, professional reference sheet quality.
Quality: professional photography, high detail, realistic, 8K.
Negative: [copy from hero exactly]
```

## Сохранение character sheet

После Pass 2 — все 9 файлов скачиваются через `download.sh`:

```
creative/assets/models/<character-slug>/
├── 01-hero-front.jpg
├── 02-three-quarter-left.jpg
├── 03-three-quarter-right.jpg
├── 04-profile-left.jpg
├── 05-profile-right.jpg
├── 06-face-closeup.jpg
├── 07-medium-portrait.jpg
├── 08-full-body-three-quarter.jpg
├── 09-above-angle.jpg
└── _vision.md
```

### Шаблон `_vision.md`

```markdown
# Character: <Name>

## Identity
- Age: <range>
- Look: <ethnicity/style descriptor>
- Distinctive: <3-4 key features that define recognition>

## Prompt signature
<Condensed 2-3 sentence subject description for reuse in all future prompts>

## Reference hierarchy
1. hero-front.jpg — primary identity reference
2. three-quarter-left.jpg — secondary (most used in lifestyle)
3. full-body — tertiary (for full body shots)

## Usage notes
<any quirks, best reference combos, what NOT to use as ref>
```

## Когда обновлять character sheet

- Новый look (другая причёска, другой возраст)
- Если drift в генерациях — перегенерировать hero pass
- НЕ обновлять character sheet только потому что одна генерация "не похожа"

## Cross-references

- Эталон с character ref: `etalon-locked-composition.md`
- Инфлюенсер recreation: `influencer-recreation.md`
- UGC с персонажем: `ugc-product-selfie.md`
