# Workflow: Personal brand — 1 фото → 10 ракурсов

**Триггер:** «фото для соцсетей», «headshots», «личный бренд», «нужно много моих фото в разных ситуациях», «бизнес-портреты»

**Continuity anchors:**
- Лицо клиента (всегда — главный lock)
- Стиль одежды если задано (или blue smart-casual / казуал по умолчанию)
- Возраст / тип

**Что меняется:**
- Локация (офис / улица / кафе / интерьер)
- Поза / выражение
- Outfit (опционально — если хочет 2-3 outfit'а на серию)

## Цепочка генераций

### Шаг 0 — Обязательный intake фото клиента

Personal brand **невозможен** без минимум 1 хорошего фото лица клиента. Перед стартом:
- Забери фото через intake → CDN URL
- Read локально → `_vision.md` с описанием: возраст / черты / hair / выражение / тип

Если есть несколько фото (анфас + полупрофиль) — даже лучше для consistency.

### Шаг 1 — Эталон (signature shot)

Один кадр который определяет стиль всей серии. Обычно:
- **Headshot 3q** — улыбка, business casual, светлый фон
- Это становится anchor для всех следующих

**Промт:**
```
Professional personal brand portrait of [клиент from reference image].
Three-quarter angle, eye level, warm genuine smile, looking at camera.
Modern minimal background — soft gradient OR clean office interior bokeh.
Soft natural light from camera-left, warm tones.
Wardrobe: smart-casual [конкретный outfit или предложи 2 опции].
Premium professional vibe but approachable, not corporate stock.

Keep face EXACTLY as in reference. Same eye color, same hair style, same age.
Avoid: corporate stock-photo cliché, fake teeth-only smile, flat lighting, distracting background props.
```

`image_urls = [<face_cdn>]`

**Vision QA:**
- Лицо узнаваемо vs референс
- Smile genuine, не painted-on
- Свет мягкий, без harsh теней
- Образ premium но не stock-photo

### Шаг 2 — Approval

### Шаг 3 — Серия 10 ракурсов (стандартный набор)

Опционально — юзер выбирает сколько (5 / 8 / 10):

| # | Контекст | Поза / mood |
|---|----------|------------|
| 1 | Headshot studio (есть, эталон) | smile, eye contact |
| 2 | Office desk | working at laptop, side-glance, focused |
| 3 | Walking outdoor | full-body, in motion, smile |
| 4 | Café meeting | sitting with coffee, leaning forward, listening |
| 5 | Standing arms-crossed | confident power pose, neutral background |
| 6 | Speaking / gesture | hands explaining, expressive |
| 7 | Looking out window | profile, contemplative |
| 8 | Casual lifestyle | weekend outfit, relaxed, smile |
| 9 | Detail / candid | close-up laughing, off-camera glance |
| 10 | Wide environmental | full-body in interesting location |

Для каждого: `image_urls=[<approved_etalon>]` + промт меняет ТОЛЬКО локацию + позу + (опционально) outfit. Всё остальное LOCKED.

## Что спрашивать

**Обязательно:**
1. Сколько ракурсов в серии? (5 / 8 / 10 / своё)
2. Главное использование? (LinkedIn / Instagram / личный сайт / press kit) — влияет на aspect ratio
3. Wardrobe — один outfit или 2-3 на серию? (опц)

**НЕ спрашивай:**
- Камера / lens
- Освещение — варьируется по локациям
- Композиция / поза — решаешь сам по таблице выше

## Что НЕ меняется

```
LOCKED:
- Face: <client face ref CDN>
- Age / type: <описание>
- Smile vibe: <genuine / professional / approachable>
- Color profile: warm-natural
```

## Кредиты

- 10 кадров на NB Pro Edit: ~180 cr (~$2)
- 10 кадров на NB 2: ~100 cr
- На GPT Image 2: ~20 cr (если нужен бюджет)

## Анти-паттерны

- ❌ Stock-photo cliché (искусственная улыбка, корпоративная одежда)
- ❌ Плоский свет (flat lighting убивает personality)
- ❌ Один и тот же фон во всех 10 кадрах — клиент будет выглядеть как фотобудка
- ❌ Менять лицо между кадрами (= вся серия в мусор, retry с усиленным «keep face exact»)

## Видео-расширение (когда подключим)

Любой подходящий still → image-to-video для talking head / vlog intro:
- Headshot → lip-sync для intro reel
- Walking outdoor → cinematic motion
- Office working → time-lapse style

Запиши в `session.md`:
```
TODO video: pb-01.jpg → talking head intro (когда подключим image-to-video)
```
