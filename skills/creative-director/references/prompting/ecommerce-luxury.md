# Ecommerce luxury — Net-A-Porter / SSENSE / luxury standard

Премиальная продуктовая съёмка. Минимализм, но с атмосферой. Нейтральная роскошь без крикливости.

## Принцип
> "Чистота с характером. Свет должен рассказывать историю качества материала. Тень — инструмент, а не ошибка."

Отличие от ecommerce clean: допустимы тонкие тени, subtle gradient, один источник с falloff.

## Locked composition (luxury version)

```
Background: light warm grey (#F5F3F0) or cool white-grey (#F0F0F2), subtle seamless.
            May include faint surface shadow for depth.
Framing: product occupies 65-75% of canvas, slight breathing room on all sides.
Lighting: single soft key light (large softbox, 45° left or right),
          beautiful natural falloff to shadow side, no fill or very subtle fill,
          rim light optional for sheen on material.
Camera: Sony A7R IV or Hasselblad, 85mm f/5.6 for clothing on model,
        100mm f/8 for still life, medium format color accuracy.
Angle: frontal eye-level (hero) or 3/4 for structural items.
Color: muted, slightly desaturated, cool or warm depending on palette.
       No neon, no oversaturated tones.
```

## Palette guidelines

| Tone | Background | Light color | Mood |
|------|-----------|------------|------|
| Cool minimal | #F0F0F2 pale grey | Cool white 5500K | Architectural, tech |
| Warm editorial | #F5F3F0 warm grey | Warm 3800K | Craft, leather, textile |
| Dark luxury | #1A1A1A near black | Soft edge light | Watches, jewellery, dark goods |
| Monochrome | Match product tone | Single source | Bold fashion statement |

Для тёмного luxury варианта — см. `product-hero.md` (elemental/dark section).

## Промт-шаблон luxury

```
Premium product photography of [PRODUCT NAME]: [description 3-4 sentences — material quality,
craftsmanship, specific luxury markers: hand-stitching, precious metal, rare leather, etc].

[If worn by model]:
Model: [description, neutral elegant pose — standing tall, slight hip shift, one hand relaxed].

Background: light warm grey seamless backdrop (#F5F3F0), subtle soft shadow
beneath product suggesting depth, no harsh background shadows.
Product fills 65-70% of frame with composed breathing room.

Lighting: single large softbox key light at 45° [left/right], beautiful natural light falloff
to shadow side creating subtle dimensionality, optional subtle rim highlight on
[material: leather edge / silk drape / metal clasp].
No fill light or very subtle bounce fill.

Camera: Hasselblad or Sony A7R IV, [85mm for model / 100mm for still life],
f/[5.6 for model / 8 for stilllife], precise color calibration, medium format quality.

Color palette: muted, slightly desaturated, [warm/cool], tones convey quiet luxury.
No color grading, no Instagram filters, accurate material color.

Quality: luxury editorial product photography, photorealistic, high detail surface texture,
8K resolution, fine art print quality.

Negative: bright saturated colors, harsh lighting, background distractions, props,
cluttered environment, sportswear aesthetic, consumer-grade feel, flat even lighting.
```

## Модель для luxury

Для одежды на модели — character должен соответствовать luxury positioning:
- Нейтральная элегантная поза: "standing tall, subtle weight shift to one leg, relaxed shoulders"
- Выражение: "composed neutral expression, quiet confidence, no smile"
- Поза НЕ динамическая — это luxury ecommerce, не editorial

Если character из `character-sheet.md` — взять hero или medium-portrait ref.

## Jewellery / watches специфика

Мелкие предметы требуют иного подхода:

```
Background: matte black velvet surface or dark brushed concrete.
Camera: 100mm macro f/11, maximum depth of field, focus stacked if needed.
Lighting: twin edge lights (both sides), creating jewel-like highlights,
          specular reflection on metal surfaces, light refraction on gemstones.
Surface: slight surface reflection on base for depth (not full mirror).
```

Добавить к промту: `"gemstone sparkle, metal lustre, edge highlight on bezel, macro surface detail"`

## Типичные ошибки

| Проблема | Fix |
|----------|-----|
| Выглядит как ecommerce clean, нет характера | Убрать even lighting, добавить single source с falloff |
| Слишком тёмно | Проверить background — #F5F3F0, не #D0D0D0 |
| Пересвет на блестящем материале | "controlled specular highlights, no overexposed hotspots" |
| Дешёвый вид несмотря на промт | Добавить "Hasselblad quality, medium format tones, fine art print" |

## Cross-references

- Базовый ecommerce: `ecommerce-clean.md`
- Fashion editorial с luxury-позиционированием: `fashion-editorial.md`
- Product hero (тёмный/элементальный): `product-hero.md`
- Lighting prest: `references/presets/lighting/single-source-falloff.md`
- Color preset: `references/presets/color/luxury-muted.md`
