# Workflow: Cinematic video — image-to-video pipeline

> **СТАТУС (2026-05-04):** Видео-моделей в Createya MCP пока нет. Этот файл — паттерн на будущее. Когда подключим Kling / Veo / Seedance / Sora / LTX — обновим routing и сделаем рабочим.

**Триггер (когда модели появятся):** «видео», «клип», «cinematic», «reels», «короткое видео», «анимация», «short»

**Continuity anchors:**
- Hero still (всегда генерится сначала, на нём всё держится)
- Палитра / lighting (наследуется из still)
- Субъект / композиция

**Что меняется в видео-стадии:**
- Motion (push-in / pan / parallax / subject motion)
- Time evolution (camera movement)
- Sound (если будет audio support)

## Текущий обходной путь

Пока видео-моделей нет — **делаем только starting frame** через image модель и сообщаем юзеру:

```
Кадр готов: <CDN URL>.
Видео-модели подключаем — этот кадр зарезервирован как hero для image-to-video когда добавим Kling V3 / Veo 3.1 / Seedance.

Записал в session.md как TODO video для этого слота.
```

Записать в `session.md`:
```
TODO video pipeline (когда подключим image-to-video модели):
- shot-01.jpg → push-in 5s
- shot-02.jpg → pan-right 3s
- shot-03.jpg → subject motion 4s
```

## Будущий полный pipeline (для документации)

### Шаг 1 — Hero still

Image модель (NB Pro / Flux 2 / GPT Image 2). Генерим в нужном aspect (обычно 16:9 для cinematic, 9:16 для reels).

### Шаг 2 — Approval still

Без approved still не идём в video — это самое дорогое место в pipeline (видео ~60–200 cr).

### Шаг 3 — Image-to-video

**Будущий выбор моделей:**
- **Kling V3 Pro** — лучший cinematic quality, identity preservation
- **Kling O3 Standard** — start-to-end frame transitions
- **Veo 3.1 reference-to-video** — премиум, reference-driven
- **Seedance 2.0** — UGC video, более динамичный
- **LTX 2.3** — fast iteration, дешевле для проб

**Промт для image-to-video** (общий паттерн):
```
Animate the static image with [motion description].
Camera: [push-in / pan-right / orbit / static / handheld].
Subject motion: [hair flutter / fabric movement / breath / blink / specific action].
Duration: [5s / 10s].
Preserve identity, lighting, palette from the source image.
Mood: [from still — cinematic / candid / commercial].
```

### Шаг 4 — Async polling

Видео — async через `mcp__createya__get_run_status`. Polling каждые ~30 секунд, не чаще. Записать estimated time юзеру.

### Шаг 5 — Download и QA

После completion — `bash ./scripts/download.sh <video_url>` → файл в `creative/sessions/<slug>/results/shot-NN.mp4`.

QA визуально (через `bash open <path>` для preview):
- Идентичность субъекта сохранена
- Motion natural, не jittery
- Длина соответствует запросу
- Финальный кадр устойчивый (не размазан)

## Будущие multi-shot sequences

Для serii из нескольких клипов:

1. **Continuity anchors** — определи в начале (lock палитра + character + location)
2. **Shot list** — 5 столбцов: shot # / narrative function / visual / camera / method (text-to-video vs image-to-video)
3. **Anchor stills first** — 1–3 ключевых stills которые покрывают мир
4. **Image-to-video для continuity-heavy** shots
5. **Text-to-video** только для exploratory / establishing
6. **Финальная сборка** — это уже не наш скилл (CapCut / Premiere / etc)

## Что спрашивать (когда подключим)

**Обязательно:**
1. Длина клипа (5s / 10s / 15s)
2. Тип motion (subtle / cinematic camera / subject action)
3. Aspect (16:9 / 9:16)
4. Финальное использование (reels / YouTube / web hero / билборд)

**Опционально:**
- Style reference (другое видео для match motion)
- Sound (когда будет audio support)

## Кредиты (ориентировочно когда подключим)

- Hero still: 10–25 cr
- Image-to-video Kling V3 Pro: ~120 cr
- Image-to-video Veo 3.1: ~150 cr
- Image-to-video Seedance 2.0: ~60 cr
- Image-to-video LTX 2.3: ~30 cr

**Двух-шаговая стратегия обязательна:** Image first → approval → video. Никогда не вали 150 cr video на не-approved концепт.

## Анти-паттерны (и сейчас и потом)

- ❌ Не пытаться делать «полный сюжет» в одном video промте — раздробить на shots
- ❌ Не использовать text-to-video если важна consistency — image-to-video всегда лучше для этого
- ❌ Не lacquerить QA — лучше запросить retry чем отдать дёрганый кадр
- ❌ Не предлагать video если модели нет в Createya — сообщи статус честно
