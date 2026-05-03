# Ecommerce clean — Wildberries / Amazon / Ozon стандарт

Максимально чистая продуктовая съёмка для маркетплейсов. Минимализм, нейтральный фон, полная видимость товара.

## Принцип
> "Товар — единственный герой. Никаких отвлекающих элементов. Покупатель должен видеть именно то, что получит."

## Locked composition (копировать в каждый промт без изменений)

```
Background: pure white seamless, #FFFFFF, no gradients, no shadows on background.
Framing: full product in frame, product occupies 70-80% of canvas.
Lighting: even soft studio lighting, no harsh shadows, no hotspots,
          diffused from both sides + top fill.
Camera: 100mm macro lens (for small items) or 50mm (for clothing/large items),
        f/8-f/11 for maximum depth of field, tripod-mounted.
Angle: frontal eye-level (hero shot).
Color: accurate color reproduction, no color grading.
```

## 5 обязательных шотов (стандарт листинга)

| # | Shot | Описание | Угол | Особенность |
|---|------|----------|------|-------------|
| 1 | Hero front | Главный кадр, центр фрейма | Frontal eye-level | 70-80% frame |
| 2 | 3/4 angle | Объём и глубина товара | 30-45° rotation | Все 3 грани видны |
| 3 | Side profile | Профиль / толщина | 90° side | Thickness/depth |
| 4 | Back | Задняя сторона | Frontal rear | Этикетки, состав |
| 5 | Detail closeup | Материал, текстура, швы | Macro 100mm | 1-2 ключевые детали |

Для одежды на модели добавляется 6-й shot: модель в движении (walking, slight turn).

## Промт-шаблон (заполнять для каждого товара)

```
Product photography of [PRODUCT NAME]: [brief description 2-3 sentences — material, color,
key features, dimensions if relevant].

[If clothing on model]:
Worn by a [gender, body type] model, [neutral standing pose / slight 3/4 turn],
arms relaxed at sides, neutral expression, clean minimal look.

Pure white seamless background, #FFFFFF, no background shadows, no gradients.
Product fills 70% of frame, fully in focus edge to edge.
Even soft diffused studio lighting from both sides plus top fill,
no harsh shadows, no specular hotspots, uniform exposure.

Camera: medium format or Sony A7R IV, 100mm macro lens (or 50mm for clothing),
f/8, tripod, ISO 100, precise color calibration.
Angle: [frontal / 3-4 left / side profile / rear / macro detail].

Colors reproduced accurately — no artistic color grading.
Quality: commercial product photography, photorealistic, high detail, 8K resolution.

Negative: background shadows, gradient background, props, decorative elements,
brand overlays, watermarks, color filters, dramatic lighting, model expressions,
background texture, reflections on floor, artistic blur.
```

## Модель / манекен / flat lay

| Вариант | Когда | Примечание |
|---------|-------|-----------|
| Ghost mannequin | Одежда без модели | Профессиональный вид, невидимый манекен — "invisible mannequin, ghost mannequin effect" |
| Модель | Если требует маркетплейс или бренд | Character из `character-sheet.md` для consistency |
| Flat lay | Аксессуары, бельё, мелкие товары | Top-down, идеальный layout |
| Ханеры / крюк | Верхняя одежда | "hanging on invisible hook, front view" |

### Phantom mannequin (invisible mannequin) prompt addition:
```
"Ghost mannequin effect: garment worn by invisible mannequin, no mannequin visible,
clothing appears to hold its shape naturally, front and back panels visible."
```

## Типичные ошибки и лечение

| Проблема | Причина | Fix |
|----------|---------|-----|
| Тени на фоне | Слишком близко к backdrop | Добавить: "zero background shadow, perfectly clean white" |
| Переэкспозиция | Мощный fill light | "no overexposed highlights, even exposure" |
| Цвет ушёл | Модель creative grading | "accurate color reproduction, no color correction, true to life colors" |
| Товар обрезан | Plompt не указал framing | "entire product visible, full product in frame, no cropping" |
| Фон серый вместо белого | Дефолт нейтраль | "pure white #FFFFFF background, not grey, not off-white" |

## Запрещено в ecommerce clean

- Тени на фоне (любые)
- Gradient/vignette фон
- Пропсы, декор, цветы, ткани рядом
- Брендированные оверлеи / watermarks
- Драматический свет (один источник, hard light)
- Художественное размытие фона
- Цветокоррекция и grading
- Неполное отображение товара

## Cross-references

- Luxury ecommerce вариант: `ecommerce-luxury.md`
- Hero product без человека: `product-hero.md`
- Эталон для серии: `etalon-locked-composition.md`
