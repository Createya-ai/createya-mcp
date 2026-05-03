# UGC realism — imperfection + skin

Если категория `ugc` или `lifestyle` — этот файл **обязателен** к применению. Без него выход выглядит "слишком студийно", AI-сгенерированно и не работает как UGC.

## Проблема

AI image gen by default делает "идеальный" свет, кожу, кадрирование, фокус. Это убивает UGC — пользователи в ленте отличают AI-фейк за полсекунды, потому что он "чистый". Реальный UGC — это imperfection: motion blur, off-center, slight overexposure, пористая кожа, lens distortion, "снято с руки на iPhone".

## Imperfection block (camera)

**Каждый prompt должен содержать** (на английском, для inject в финальный promt):

```
Camera imperfections (mandatory): handheld iPhone aesthetic, slight motion blur on edges,
off-center framing (subject shifted from perfect rule-of-thirds), occasional soft focus on
secondary elements, slight overexposure on highlights from indoor lighting, subtle lens
distortion at frame edges (visible in straight lines), small grain in shadows, candid
unposed feel.
```

Это даёт ~50 слов специфики которые помещают output в "real-person-shot-this" пространство, а не "studio shoot".

## Skin realism block (mandatory для людей)

**Каждый prompt с человеком** должен включать **3-4 cues** (выбирай из этого списка, не используй все сразу):

✅ **Используй** (даёт "real person, not retouched"):
- visible pores on cheeks and nose
- slight unevenness in skin tone (subtle variation, not blotchy)
- minor undereye shadows
- hint of natural shine from skin oils
- faint texture lines around eyes/mouth (laugh lines, expression lines)
- subtle freckles or moles (if appropriate to character)
- light asymmetry in features (one eyebrow slightly higher, etc)
- natural lip texture (not glossy plastic)

❌ **НЕ используй** (даёт "person with skin problems"):
- acne, pimples, breakouts
- redness, irritation
- blemishes, spots
- scars, marks
- visible pores everywhere (только cheek/nose ОК)

## Reference order

Для UGC product selfie (модель + товар):

1. **Character reference** first — strongest identity signal. Модель не должна меняться между кадрами серии.
2. **Product reference** second — товар фиксируется как часть кадра.
3. **Style/aesthetic refs** third — мудборды локации/настроения.

Не наоборот: если product reference идёт первым, модель "плывёт" в серии вариаций.

## Pose & expression cues

Реальный человек на UGC снимке **не позирует**:

✅ Ok:
- weight shifted to one leg, asymmetric stance
- hand mid-action (about to pick up product, holding it casually)
- looking slightly off-camera (engaged but not posing)
- mouth slightly open mid-word (mid-sentence vibe)
- candid laugh (not posed smile)
- one eyebrow raised in expression
- caught-in-motion grip on product

❌ НЕ ok для UGC:
- perfect symmetric stance
- staged smile / fashion gaze direct-camera
- "demonstration" pose holding product like an ad
- formal posture

## Lighting для UGC

Не studio. Реалистичный микс:

- Window light (north-facing soft / south-facing direct)
- Practicals (warm room lamps in frame)
- Mixed temperature (3200K bulbs + 5500K window)
- Acceptable spill, hot spots from screen / mirror
- NOT softbox + reflector "perfect" beauty light

См. lighting presets:
- `natural-window` — главный default
- `mixed-practical` — окно + lamps
- `ring-light` — для selfie-стиля (influencer phone)

## Где применять

| Категория | UGC realism применяется? |
|---|---|
| `ecommerce` clean | НЕТ — нужна студийная чистота |
| `ecommerce` luxury | НЕТ |
| `fashion` editorial | НЕТ — там специально "polished" |
| `personal_brand` corporate | НЕТ |
| `personal_brand` creative/intimate | ЧАСТИЧНО (skin realism да, imperfection — мягко) |
| `portfolio` | НЕТ |
| `product_artistic` | НЕТ (если стиль не lifestyle) |
| `product_artistic` lifestyle | ДА |
| `ugc` любой | **ДА (полный набор)** |
| `lifestyle` | ДА |

## Output структура для UGC prompt

```
Subject (with skin realism block embedded inline) +
Clothing (casual, lived-in, not freshly pressed) +
Pose & expression (candid cues from list above) +
Background (realistic environment with normal clutter — kitchen with dishes, desk with notebook,
bathroom with toothbrush in frame, gym with locker visible) +
Lighting (mixed natural + practicals from list above) +
Camera imperfections block (full block from this file) +
Style markers (UGC raw / iPhone / candid / influencer) +
Quality markers (8K only if hyperrealistic; иначе don't say 8K — это даёт perfect)
```

**Минимум 250 слов** в final prompt (как в etalon-locked-composition).

## Видео UGC

Для UGC video (seedance-2-0, veo3.1) — все правила выше + дополнительно:

**Human motion cues (mandatory)** — 3-4 на prompt:
- breaking eye contact mid-sentence
- head tilts as she pauses
- subtle weight shifts on feet
- grip adjustments on product
- glancing at product while explaining
- finger fidgets
- natural blink rate (не staring contest)

Без этих cues видео-модели делают "frozen mannequin talking" — мёртвый взгляд, неподвижное тело.

**No subtitles / captions** — каждый prompt должен заканчиваться:
```
Critical: no subtitles, no captions, no text overlays, no on-screen text whatsoever.
```

Многие video моделей burn captions in by default.
