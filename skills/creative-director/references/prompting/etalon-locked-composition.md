# Etalon — locked composition

Главная формула skill'а. Эталон — это **первый кадр серии**, который фиксирует визуальный язык всей фотосессии. Все вариации потом дословно копируют субъект+одежду из эталона и меняют только ракурс/позу/кадрирование.

## Принцип

> "Эталон — это reference shot для image-to-image consistency. Не креативный кадр, а технически выверенный baseline."

Композиция эталона **жёстко зафиксирована** правилами категории — ты не выбираешь её творчески. Творчество — в описании субъекта. Это даёт image-to-image моделям (nano-banana-pro, flux-2) надёжную точку отсчёта для генерации вариаций.

## Структура promта эталона

В порядке от most-important к contextual:

1. **Subject (3-4 sentences)** — детальное описание главного субъекта
   - Для модели: пол, возраст, этнотип, цвет волос (длина/причёска), глаза, черты лица, телосложение, кожа (фактура), макияж
   - Для товара: что это, материал, цвет, фактура, фасон, отделка, размер, особенности
   - Если есть референсы — копируй детали с них **дословно**

2. **Clothing / accessory (3-4 sentences)** — каждый предмет одежды отдельно (если применимо)
   - Верх / низ / обувь / аксессуары
   - Цвет, материал, фактура ткани, крой, как сидит на фигуре

3. **Locked composition** — копируй из правил категории, НЕ адаптируй:
   - Фон / локация
   - Кадрирование (full body / waist-up / close-up)
   - Камера / объектив / диафрагма
   - Освещение
   - Ракурс

4. **Style markers** — общая эстетика по style preset
5. **Quality markers** — "professional photography, high detail, realistic, 8K"
6. **Negative constraints** — "no text, no watermark, no logo overlay, no artifacts, no extra fingers, no merged objects"

**Минимум 250 слов финального promта**.

## Правила locked composition по категории

### Ecommerce (clean)

```
Background: pure white seamless backdrop, no shadow on background, no gradient
Framing: full subject in frame, subject occupies 70% of canvas, centered
Lighting: even soft studio lighting, large softbox key + fill, no harsh shadows on product/clothing
Camera: 100mm macro f/8 (product) / 50mm f/8 (clothing on model), tripod-mounted, perpendicular
Angle: frontal eye-level, no perspective distortion
```

### Fashion editorial

```
Background: depending on style — white cyclorama, location, color seamless
Framing: full body, model occupies ~80% of vertical space, centered or left-third
Lighting: soft three-point studio (softbox key 90x120cm, fill softbox 60x60cm at 1:2 ratio, strip rim)
Camera: Sony A7R IV, 85mm f/5.6, sharp focus across the body
Angle: frontal eye-level, neutral pose, hands relaxed at sides, neutral expression
Critical: face AND clothing fully sharp and visible
```

### Personal brand

```
Background: light grey seamless OR neutral interior with soft bokeh
Framing: waist-up (chest to top of head), face in upper third, slight headroom
Lighting: soft natural daylight from large source or soft three-point
Camera: 85mm f/2.8, sharp focus on face, soft bokeh background
Angle: frontal eye-level, straight posture, friendly neutral expression
```

### Portfolio (modeling)

```
Background: neutral grey seamless OR pure white seamless
Framing: full body, model 80% of frame height, centered
Lighting: classic studio three-point softbox setup (5500K daylight)
Camera: 85mm f/5.6, sharp across the frame
Angle: frontal eye-level, hands relaxed at sides, neutral face
Outfit: neutral basic (black/white/grey topcoat, fitness wear) — cuts not part of fashion
```

### Product artistic

```
Background / location: USE values from brief (location, mood, atmosphere) — НЕ хардкоди
Framing: hero shot, product 60% of frame
Lighting: USE from brief (mood + lighting preset)
Camera: 50mm f/4, sharp on product, environment readable but not distracting
Angle: eye-level OR slight high-angle (3-5°)
Critical: product in focus, surroundings support but never compete
```

### UGC product selfie / lifestyle

```
Background: realistic environment matching the use case (kitchen, bathroom, gym, car, desk)
Framing: half-body or chest-up, slight off-center (not perfectly composed — это UGC)
Lighting: natural mixed (window + practicals), soft side direction, NOT studio
Camera: phone/handheld aesthetic — slight motion blur, soft focus on edges, possible slight overexposure
Angle: arm's-length selfie OR over-the-shoulder candid
Critical: see UGC realism formula — imperfection block + skin realism mandatory
```

## Что зависит от категории, что НЕТ

| Параметр | Где определяется |
|---|---|
| Subject описание | LLM (на основе референсов + brief) |
| Clothing описание | LLM (с референсов / описания) |
| Background | Locked rules категории |
| Framing | Locked rules категории |
| Lighting | Locked rules категории + опц. lighting preset из brief |
| Camera | Locked rules категории + опц. camera preset |
| Style markers | Style preset из brief |

## Output

Чистый текстовый promt, БЕЗ преамбул, БЕЗ заголовков, БЕЗ пунктов — один длинный абзац на английском (генеративные модели лучше воспринимают английский). Минимум 250 слов.

```
A 28-year-old fashion model with long honey-blonde wavy hair...
```

(не "Here is the prompt:" — сразу контент.)

## Workflow

```
1. Юзер дал бриф + референсы
2. Skill читает _vision.md референсов (или Read'ит файлы если нет)
3. Определяет категорию → подгружает locked composition rules выше
4. Подгружает выбранные пресеты (lighting, color, camera, style) — берёт inject_text
5. Собирает финальный 250+-словный prompt
6. mcp__createya__run_model({ model: "nano-banana-pro", input: { prompt, reference_image_urls } })
7. download.sh → Read для QA → если ОК показать юзеру → ждать approval
```

## Запрещено в эталоне

- Креативная композиция (это для вариаций)
- Динамическая поза (для эталона — нейтральная)
- Драматичный свет (для эталона — равномерный)
- Художественные ракурсы (низкий, dutch, etc — для вариаций)
- Movement, motion blur (эталон должен быть резким)
