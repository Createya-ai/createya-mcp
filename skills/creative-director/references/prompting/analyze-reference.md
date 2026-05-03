# Analyze reference — reverse-engineering чужого фото/видео

Workflow для декомпозиции референсного изображения или видео в reusable prompt template. Skill читает ref → разбирает на слои → сопоставляет с пресетами → создаёт шаблон.

## Принцип
> "Не 'сделай так же' — а 'пойми почему это работает и сделай своё'."

Это аналитический workflow. Skill НЕ запускает генерацию. Только декомпозиция и template.

---

## Шаг 1 — Read reference

Skill читает изображение через Read tool. Для видео — анализирует стоп-кадры.

```
Sources:
- URL из assets-index: creative/assets/{category}/<slug>/
- CDN URL: передан напрямую
- Локальный путь: creative/sessions/<id>/references/
```

---

## Шаг 2 — Decompose into layers

Skill разбивает изображение по 7 слоям:

### Layer 1: Subject

```
Questions:
- Кто/что в кадре? (person, product, scene, abstract)
- Если человек: demographics, styling, expression, energy
- Если товар: what, material, color, placement
- Масштаб в кадре (% от frame)
- Relationship to environment
```

Output: `subject: "<description>"`

### Layer 2: Composition

```
Questions:
- Framing: tight / medium / wide / full body / environmental
- Subject placement: center / rule of thirds / extreme left-right / floating
- Angle: frontal / 3-4 / profile / overhead / low-angle / dutch tilt
- Crop: где обрезано (waist / chest / face only)
- Aspect ratio feel: square / portrait / landscape / cinema 2.39:1
- Negative space: есть ли? где?
```

Output: `composition: "<description>"`

### Layer 3: Lighting

```
Questions:
- Source type: natural / studio / practical / mixed
- Source direction: frontal / 45° left / 45° right / backlit / overhead / from below
- Quality: hard (sharp shadows) / soft (diffused) / mixed
- Key-to-fill ratio: high contrast / balanced / flat fill
- Color temperature: warm (amber/yellow) / neutral / cool (blue)
- Special elements: lens flare / backlit halo / bokeh highlights / practical light sources
- Time of day if outdoor: golden / blue / midday / overcast
```

Output: `lighting: "<preset match or description>"`
Preset match: cross-reference `references/presets/lighting/`

### Layer 4: Color

```
Questions:
- Overall palette: warm / cool / neutral / mixed
- Saturation level: high / medium / muted / desaturated / B&W
- Key colors: what hues dominate?
- Color grading signature: teal-orange / warm film / cool clean / vintage / etc
- Skin tones: warm/cool/natural
- Shadow color: is there a cool push in shadows (common in cinema)?
```

Output: `color: "<preset match or description>"`
Preset match: cross-reference `references/presets/color/`

### Layer 5: Camera / Lens

```
Questions:
- Depth of field: shallow (bokeh background) / deep (sharp throughout) / medium
- Estimated focal length from DOF + perspective:
  - Very shallow DOF + slight compression = 85mm+
  - Natural perspective + some DOF = 50mm
  - Wide environment, minimal compression = 24-35mm
  - Extreme macro / product = 100mm
- Grain/noise visible? → suggests high ISO or film emulation
- Motion blur? → suggests slow shutter or in-camera motion
- Lens distortion? → wide angle
```

Output: `camera: "estimated <focal length>mm f/<aperture>, [film grain if present]"`

### Layer 6: Style / Aesthetic

```
Questions:
- Genre: editorial / UGC / ecommerce / lifestyle / advertising / fine art / documentary
- Publication feel: Vogue / iPhone photo / advertising campaign / TikTok / etc
- Era/period: contemporary / retro / timeless / futuristic
- Mood words (3-5): [intimate, powerful, nostalgic, fresh, etc.]
- What makes it distinctive?
```

Output: `style: "<genre + 3-5 mood words>"`
Preset match: cross-reference `references/presets/style/`

### Layer 7: Atmosphere

```
Questions:
- Environment: urban / natural / studio / interior / abstract
- Time of day / season?
- Weather / conditions?
- Story: what happened before / what happens after?
- Emotional response this image creates: calm / excited / melancholic / inspired
```

Output: `atmosphere: "<description>"`

---

## Шаг 3 — Identify preset matches

После decomposition — сопоставить с существующими пресетами.

```
Lighting → check: references/presets/lighting/
  Candidates: soft-three-point / single-source-falloff / golden-hour /
              low-key-chiaroscuro / natural-window / edge-light-product

Color → check: references/presets/color/
  Candidates: luxury-muted / warm-film / cool-editorial / ugc-authentic / etc

Style → check: references/presets/style/
  Candidates: editorial-vogue / ugc-raw-authentic / personal-brand-creative /
              product-artistic-moody / etc

Camera → identify focal length range + aperture class
```

Если совпадения нет — описывать напрямую.

---

## Шаг 4 — Write template prompt

Template с плейсхолдерами для подстановки нового субъекта.

### Output format

```markdown
# Template: [reference name/description]

## Decomposition summary
- Subject: [Layer 1 output]
- Composition: [Layer 2 output]
- Lighting: [Layer 3 output] → preset: [if matched]
- Color: [Layer 4 output] → preset: [if matched]
- Camera: [Layer 5 output]
- Style: [Layer 6 output] → preset: [if matched]
- Atmosphere: [Layer 7 output]

## Reusable prompt template

[SUBJECT_PLACEHOLDER — describe your subject here: 3-4 sentences].

[COMPOSITION from Layer 2 — copy verbatim]:
[LIGHTING inject_text from matched preset OR Layer 3 description].
[CAMERA from Layer 5: focal length, aperture].

Color treatment: [Layer 4 description].
Style: [Layer 6 description].
Atmosphere: [Layer 7 description].
Quality: professional photography, photorealistic, high detail, 8K.
Negative: [infer from style — what would break this look?]

## Swap notes
- To swap subject: replace SUBJECT_PLACEHOLDER
- To swap product: add clothing/product block after subject
- Lighting preset: [preset name] — inject_text from preset file
- Color preset: [preset name] — inject_text from preset file
- Do NOT change: [composition rules / specific lighting angles that define this look]
```

---

## Шаг 5 — Save

```
creative/sessions/<session-id>/
├── template.md          ← шаблон из этого workflow
├── reference.jpg        ← оригинальный референс
└── decomposition.json   ← структурированная декомпозиция
```

### decomposition.json структура

```json
{
  "analyzed_at": "2026-05-03",
  "source_url": "<original url or path>",
  "layers": {
    "subject": "<description>",
    "composition": "<description>",
    "lighting": "<description>",
    "lighting_preset": "<preset name or null>",
    "color": "<description>",
    "color_preset": "<preset name or null>",
    "camera": "<description>",
    "style": "<description>",
    "style_preset": "<preset name or null>",
    "atmosphere": "<description>"
  },
  "template_file": "template.md"
}
```

---

## Что НЕ делает этот workflow

- НЕ запускает генерацию — только декомпозиция и template
- НЕ копирует изображение — создаёт prompt-инструмент
- НЕ гарантирует "такой же результат" — воссоздаёт визуальный язык

Для запуска генерации по template → передать в `etalon-locked-composition.md` workflow.

---

## Cross-references

- Эталон по template: `etalon-locked-composition.md`
- UGC анализ: `ugc-realism.md`
- Fashion editorial анализ: `fashion-editorial.md`
- Все пресеты: `references/presets/`
