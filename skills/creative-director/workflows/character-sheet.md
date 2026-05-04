# Workflow: Character sheet — 9 ракурсов AI-персонажа

**Триггер:** «character sheet», «AI-модель», «9 ракурсов», «создай персонажа», «AI-инфлюенсер», «virtual model»

**Continuity anchors:**
- ВСЁ лицо (черты до миллиметра)
- Hair (цвет / длина / стрижка / fall)
- Тип фигуры
- Возраст
- Skin tone

**Что меняется:**
- Только ракурс камеры
- Только освещение (опционально — но лучше держать одно для consistency на следующих съёмках)
- НЕ меняется outfit (в character sheet всегда один — обычно нейтральный bodysuit / smart casual)

## Цель character sheet

Создать reference set чтобы во всех будущих съёмках использовать как `image_urls=[front, 3q, side]` для максимальной consistency лица.

**Это инфраструктура для дальнейших проектов**, не финальный контент.

## Цепочка генераций

### Шаг 0 — Дефиниция персонажа

Юзер описывает персонажа. Если описание короткое — задай 2 уточняющих вопроса:

**Обязательно нужно знать:**
- Возраст (24 / 28 / 32 / etc — НЕ диапазон)
- Тип лица (oval / heart / round / square / diamond)
- Hair (цвет точный + текстура + длина + стрижка)
- Skin tone (pale / medium / olive / dark с подтоном)
- Body type (slim / athletic / curvy / petite)
- Eyes (цвет + форма)

Пример:
```
CHARACTER SHEET: Sofia
- Age: 28
- Face: oval, soft jawline, slight asymmetry (left side stronger)
- Hair: natural dark brown, long straight, shoulder-length, side part
- Skin: medium olive with warm undertone
- Body: slim athletic, 168cm
- Eyes: hazel-green, almond shape
- Lips: medium full, neutral nude
- Distinguishing: subtle freckles across nose bridge, small mole left cheek
```

Это записывается в `creative/assets/models/<slug>/_character.md` ПЕРЕД генерацией.

### Шаг 1 — Anchor shot (front straight)

**Модель:** Nano Banana Pro (для лучшего сохранения features) или Flux 2

**Промт:**
```
Character reference sheet — front straight portrait.
[Полный character description из _character.md]
Wardrobe: simple smart-casual neutral — white fitted t-shirt, no jewelry, no makeup or minimal nude.
Background: pure neutral grey seamless studio backdrop.
Lighting: soft three-point studio, even, no dramatic shadows. Designed for character reference.
Camera: 85mm, eye level, head and shoulders, perfect anatomy reference.
Photorealistic, sharp focus, neutral color profile.
Avoid: stylization, makeup, jewelry, props, dramatic lighting, color grading, expressions.
Subject must look directly at camera with neutral expression.
```

**Vision QA:**
- Лицо симметрично (если не задана asymmetry)
- Все черты читаются (глаза / нос / рот / линия челюсти)
- Skin natural texture
- Цвет нейтральный (не warm / не cool — будем менять в съёмках)

**Если что-то не совпадает с character_md** — retry с дополнениями. Anchor shot должен быть на 100% корректен, иначе вся будущая работа сломается.

### Шаг 2 — Approval

**Без approval — стоп.** Эта картинка станет основой для всех дальнейших съёмок этого персонажа.

### Шаг 3 — 8 ракурсов (после approval)

Каждый — `image_urls=[<approved_anchor>]` + промт меняет только угол.

| # | Ракурс | Что важно |
|---|--------|-----------|
| 1 | **Front straight** (есть) | Anchor |
| 2 | **3q left** | 3/4 поворот налево, лицо видно полностью |
| 3 | **3q right** | 3/4 поворот направо, симметрично #2 |
| 4 | **Profile left** | Чистый профиль слева |
| 5 | **Profile right** | Чистый профиль справа |
| 6 | **Slight up-tilt** | Подбородок чуть вверх — для съёмок снизу |
| 7 | **Slight down-tilt** | Подбородок чуть вниз — для съёмок сверху |
| 8 | **Back of head** | Затылок — для волос reference |
| 9 | **Smile / expression** | Один кадр с лёгкой улыбкой — чтобы видеть лицо в эмоции |

Для каждого: «Same person from reference image. Change angle to: [ракурс]. Keep: face exact, hair exact, wardrobe same, lighting same, background same. Identical character reference style.»

### Шаг 4 — Сохранение в assets

Все 9 кадров → `creative/assets/models/<slug>/`:
- `01-front.jpg`
- `02-3q-left.jpg`
- ... etc
- `_character.md` (описание)
- `_vision.md` (что Claude видит на каждом кадре)
- `_cdn-urls.json` (CDN URLs для использования в будущих сессиях)

После этого персонаж готов для использования в любом workflow (lookbook / personal-brand / editorial / UGC).

## Что спрашивать

**Обязательно:**
1. Описание персонажа (все 7 параметров выше)
2. Имя / slug для папки

**НЕ спрашивай:**
- Outfit — всегда нейтральный для character sheet
- Локация — всегда нейтральный grey backdrop
- Освещение — всегда soft three-point
- Кол-во кадров — всегда 9 (стандарт)

## Что НЕ меняется

```
LOCKED across all 9 shots:
- Face (exact features per character_md)
- Hair (color, texture, length, style)
- Skin tone
- Body type
- Wardrobe (same neutral outfit)
- Background (same neutral grey)
- Lighting (same soft three-point)
```

## Кредиты

- 9 кадров на NB Pro = ~162 cr
- На Flux 2 = ~225 cr

Один раз потратил — character доступен на любые будущие съёмки.

## Анти-паттерны

- ❌ Делать character sheet с разным освещением между ракурсами — потеряется consistency
- ❌ Делать character sheet с outfit / makeup / props — это reference set, не fashion shoot
- ❌ Менять выражение лица между ракурсами (кроме #9) — нужно нейтральное для anatomical reference
- ❌ Использовать stylized backgrounds — chаrа должен «жить» в нейтральной среде

## Видео-расширение

Не применимо для character sheet (это инфраструктура, не контент). Видео делается уже в дальнейших lookbook / editorial / personal-brand сессиях которые используют этот character.
