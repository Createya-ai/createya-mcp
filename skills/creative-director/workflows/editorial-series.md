# Workflow: Editorial series — 5–8 кадров locked aesthetic

**Триггер:** «editorial», «fashion shoot», «съёмка для журнала», «арт-серия», «концептуальная серия»

**Continuity anchors:**
- Эстетика (главное — палитра / mood / film grade)
- Лицо/тело модели
- Wardrobe / styling concept
- Локация ИЛИ вселенная (одна локация ИЛИ один visual world через несколько мест)

**Что меняется:**
- Кадрирование (wide → medium → close → detail → environmental)
- Композиция / угол камеры
- Поза / выражение
- Микро-действия

## Цепочка генераций

### Шаг 0 — Дефиниция эстетики (5 минут)

Перед первой генерацией — **сожми концепт в одну фразу + 3 anchor'а**:

```
ESTHETIC SHEET:
- One-line: "Cold-blue brutalist tower at dawn, isolated woman in red, melancholy elegance"
- Color anchors: cold blue (#3a5a78), concrete grey (#888), accent red (#a3192e)
- Light language: overcast diffused, slightly underexposed, lifted shadows
- Mood: quiet, distant, intentional, premium European fashion mag (Self Service / Document)
- Anti: warm tones, smile, candid, busy backgrounds
```

Это записывается в `session.md` ПЕРЕД первой генерацией.

### Шаг 1 — Эталонный hero

**Модель:** Nano Banana Pro / Flux 2 / Midjourney (если стилизация важнее реализма)

**Промт:**
```
[Esthetic sheet one-liner]
[Subject: detailed]
[Outfit / styling: detailed]
[Location: detailed]
[Camera: lens / framing — "wide cinematic" or "tight editorial"]
[Light: from esthetic sheet]
[Mood adjectives: from esthetic sheet]
[Color palette: from esthetic sheet, with HEX]
Designed as premium editorial spread for [magazine reference if helpful — Self Service, Document, Re-Edition].
Avoid: [anti-list from esthetic sheet]
```

**Vision QA editorial:**
- Композиция читается как «снимал человек», не «угадал AI»
- Палитра выдержана (не вылезли warm tones если concept cold)
- Mood считывается с одного взгляда
- Лицо / тело модели натуральны

### Шаг 2 — Approval (КРИТИЧНО)

Editorial — это про эстетику. Если эталон не на 100% попал в концепт — итерируем эталон до победы. **Лучше потратить 5 кадров на эталон чем 8 на series которая разваливается.**

### Шаг 3 — Серия 5–8 кадров

Стандартный editorial sequence:

| # | Тип кадра | Функция |
|---|-----------|---------|
| 1 | **Hero / opening spread** | Эталон, устанавливает мир (есть) |
| 2 | **Wide environmental** | Модель vs мир, малая фигура в большом пространстве |
| 3 | **Medium portrait** | 3q, выражение, character |
| 4 | **Close-up detail** | Лицо / руки / ткань — texture & emotion |
| 5 | **Action / movement** | Шаг / поворот / жест |
| 6 | **Symbolic / abstract** | Деталь объекта, тень, силуэт — без лица |
| 7 | **Counter-shot** | Со спины / другой стороны |
| 8 | **Closing image** | Возврат к hero вибу, но с новой эмоциональной нотой |

Для каждого: `image_urls=[<approved_etalon>]` + промт меняет ТОЛЬКО кадрирование/угол/позу. Палитра / свет / mood — **дословно из esthetic sheet**.

### Шаг 4 — Финальный grading check

После всех кадров — `Read` каждый и сравни попарно:
- Палитра одинакова?
- Mood выдержан?
- Если 1–2 кадра выбиваются — retry именно их с усиленным «match exact color profile of image 1»

## Что спрашивать

**Обязательно:**
1. Концепт одной фразой ИЛИ референс-изображения
2. Модель (есть фото или генерим типаж?)
3. Локация — одна / меняется / абстрактная

**Опционально:**
- Журнал-референс (Self Service / Document / Vogue / Re-Edition / собственный) — для калибровки эстетики
- Кол-во кадров (5 / 8 / своё)

**НЕ спрашивай:**
- Камера / lens — варьируется по серии
- Освещение — единое из esthetic sheet
- Поза каждого кадра — решаешь по таблице

## Что НЕ меняется

Дословно esthetic sheet из шага 0. Каждая новая генерация начинается с цитирования one-liner и anchors.

## Кредиты

- 8 кадров на NB Pro = ~144 cr
- 8 кадров на Flux 2 = ~200 cr
- 8 кадров на Midjourney (если стилизация) = варьируется

## Видео-расширение (когда подключим)

Editorial → cinematic motion clips. Каждый approved still → image-to-video с минимальным движением (push-in / parallax / hair flutter / fabric movement). Сохраняет эстетику, добавляет depth.

```
TODO video: editorial-01.jpg → push-in 5s (когда подключим image-to-video)
TODO video: editorial-04.jpg → hair flutter 3s
```

## Анти-паттерны

- ❌ Серия без esthetic sheet — каждый кадр пойдёт в свою сторону, развалится
- ❌ Менять палитру между кадрами — если 1 кадр warm среди cold — серия мертва
- ❌ Использовать «cinematic / editorial / fashion» как теги вместо описания — модель не поймёт
- ❌ Делать editorial без negative space / breathing room — editorial = тишина, не overcrowded
