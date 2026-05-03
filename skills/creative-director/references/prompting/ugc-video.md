# UGC video — видео-отзыв AI инфлюенсера

Формула для UGC-видео с продуктом (Seedance 2.0 / Veo 3.1 / Sora 2 / Kling). 9-layer структура + обязательные технические блоки.

## Принцип
> "Настоящий UGC видео — это история за 15-30 секунд. Структура: зацепи → покажи → докажи → призови."

ОБЯЗАТЕЛЬНО применять camera imperfections и human motion cues. Без них получается "frozen mannequin talking".

---

## 9-layer formula

### Layer 1 — Opener hook (1-2 секунды)
Первые 2 секунды решают всё. Должен быть pattern interrupt.

```
Hook types:
- Visual surprise: unexpected action / unusual angle / product reveal from hidden position
- Reaction hook: genuine laugh / surprised expression / "wow" moment
- Mid-action: начать с движения, не с ожидания начала
```

Prompt: "Opening 1-2 seconds: [specific hook action — 'character turns to camera mid-laugh' /
'product suddenly revealed from behind back' / 'character already mid-demonstration']"

### Layer 2 — Product reveal (2-4 секунды)
Товар показывается чётко. Этикетка/брендинг видны.

```
"[Product name] clearly visible and in focus, held [in front of face / to camera level /
in demonstrating hand], brand/label clearly readable, natural casual presentation."
```

### Layer 3 — Demonstration (5-10 секунд)
Использование товара в действии. Самая длинная часть.

```
"Character demonstrates [specific use action] naturally and confidently,
[product interaction specifics], authentic engagement."
```

### Layer 4 — Reaction (2-3 секунды)
Эмоциональная реакция на использование.

```
"Genuine positive reaction: [impressed nod / subtle satisfied smile / excited eyes /
approving head tilt], not over-the-top acting."
```

### Layer 5 — Verdict (2-3 секунды)
Вербальное или невербальное "вот вывод".

```
"[Spoken verdict from script] OR [thumbs up / chef's kiss gesture / 
approving camera look / subtle confident nod]"
```

### Layer 6 — CTA (1-2 секунды)
Call-to-action. Может быть spoken или gesture.

```
"[CTA from script] OR [pointing gesture toward camera / 
subtle 'check it out' head nod / product held toward camera]"
```

### Layers 7-9 — Технические обязательные блоки

**Layer 7 — Camera imperfections (ВСЕГДА)**
```
Camera imperfections: handheld iPhone aesthetic, slight motion blur on edges,
off-center framing, occasional soft focus, slight overexposure on highlights,
subtle lens distortion at frame edges, small grain in shadows, candid unposed feel.
```

**Layer 8 — Human motion cues (ВСЕГДА — против frozen mannequin)**
```
Human motion cues: natural micro-movements throughout — breaking eye contact briefly,
subtle head tilts when thinking, natural weight shifts from foot to foot,
occasional grip adjustments on product, natural blink rate, slight body sway.
Avoid: frozen robot stillness, unnatural perfect stillness between movements.
```

**Layer 9 — No subtitles (ВСЕГДА)**
```
Critical: no subtitles, no captions, no text overlays, no lower thirds,
no on-screen graphics of any kind.
```

---

## Word count → duration mapping

| Spoken words | Approx duration | Тип видео |
|-------------|----------------|---------|
| 0 слов | 5-10 сек | Silent visual demo |
| 15-20 слов | 8-10 сек | Quick review |
| 30-40 слов | 15-18 сек | Standard UGC |
| 60-75 слов | 28-32 сек | Full review |
| 100+ слов | 45+ сек | Deep dive |

Средняя скорость речи: **2.5 слова в секунду** для casual-conversational tone.

---

## Dialogue confirmation gate

ОБЯЗАТЕЛЬНЫЙ шаг перед генерацией с audio.

Skill извлекает spoken text и предъявляет юзеру:

```
SPOKEN TEXT FOR REVIEW:
---
[Exact words the character will say]
---
Word count: X words
Estimated duration: Y seconds

Instructions:
1. Read this out loud at conversational speed
2. Does the timing match your target?
3. Does the tone feel authentic for this character?
4. Any words to change?

Type "approved" to generate, or provide changes.
```

После approval — генерация с `audio: true`.

---

## Полный prompt template

```
UGC video testimonial: [CHARACTER DESCRIPTION — 2-3 sentences from character sheet].

[CHARACTER] is creating an authentic UGC review of [PRODUCT DESCRIPTION — name, what it is].

VIDEO STRUCTURE (total ~[X] seconds):
OPENER (0-2s): [specific hook from Layer 1]
REVEAL (2-4s): [product reveal description from Layer 2]  
DEMO (4-14s): [demonstration action from Layer 3]
REACTION (14-17s): [reaction description from Layer 4]
VERDICT (17-20s): [verbal or gestural verdict from Layer 5]
CTA (20-22s): [call to action from Layer 6]

[IF AUDIO ENABLED]:
SPOKEN CONTENT:
"[Full script — every word character says]"

Environment: [setting — kitchen / bathroom / outdoor / bedroom etc, 2-3 sentences].

Lighting: [ugc-appropriate: ring light / natural window / practical ambient].

Camera imperfections: handheld iPhone aesthetic, slight motion blur on edges,
off-center framing, occasional soft focus, slight overexposure on highlights,
subtle lens distortion at frame edges, small grain in shadows, candid unposed feel.

Human motion cues: natural micro-movements throughout — breaking eye contact briefly,
subtle head tilts when thinking, natural weight shifts, occasional grip adjustments,
natural blink rate, slight body sway.

Critical: no subtitles, no captions, no text overlays, no on-screen graphics.

Style: authentic UGC creator content, platform-native feel [TikTok / Instagram Reels / YouTube Shorts].
Quality: photorealistic motion, consistent identity, smooth natural movement.

Negative: professional broadcast quality feel, frozen stillness, robot-like movement,
captions or text of any kind, different person than reference.
```

---

## Модели и рекомендации

| Модель | Лучше для | Параметры |
|--------|---------|----------|
| Seedance 2.0 | Реализм + motion quality | duration: 10-15s |
| Veo 3.1 | Audio + complex actions | duration: 8s, audio: true |
| Kling 2.1 | Long form + consistency | duration: 10-30s |
| Sora 2 | Creative/artistic UGC | duration: 5-20s |

---

## Audio: enabled или disabled?

| Сценарий | Audio |
|---------|-------|
| Quick visual demo | `false` — добавляется музыка при монтаже |
| Review с речью | `true` — только Veo 3.1 или модели с audio поддержкой |
| Background music нужна | `false` — нет контроля над AI-музыкой |
| Organic voice persona | `true` + dialogue gate |

---

## Cross-references

- ОБЯЗАТЕЛЬНО: `ugc-realism.md` — camera imperfections + skin realism
- UGC still (selfie формат): `ugc-product-selfie.md`
- Product showcase (narrative, не review): `product-showcase.md`
- Character для видео: `character-sheet.md`
- Real person в видео: `influencer-recreation.md`
