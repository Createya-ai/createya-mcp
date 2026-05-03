# Presets — мастер-каталог

Профессиональная библиотека пресетов фотосъёмки. **8 категорий**, каждый пресет = markdown с YAML frontmatter + развёрнутым описанием + готовым `inject_text` для подмешивания в etalon prompt.

## Категории

| Папка | Содержит | Кол-во из коробки |
|---|---|---|
| `lighting/` | Схемы света: studio (three-point, butterfly, Rembrandt, beauty clamshell, split, loop, broad/short), natural (window, golden hour, blue hour, overcast, backlight), product (tabletop tent, edge light), creative (high-key, low-key, hard-light, ring, mixed practical) | ~25 |
| `color/` | Цветокор: Luxury muted, Vibrant ecommerce, Hi-key clean, Filmic warm/cool, Cinematic teal-orange, Bleach bypass, B&W high/low contrast, Film grain heavy/subtle, Pastel UGC, Editorial deep blacks, Sunset golden, Moody dark teal | ~18 |
| `camera/` | Lens & framing: Portrait 85mm/105mm, Beauty 100mm macro, Fashion 50mm/35mm, Environmental 24mm, Full-body 35mm, Flat-lay top-down, Hero low-angle, Macro detail, Tilt-shift miniature, Tele compressor 135mm, Telephoto 200mm | ~15 |
| `composition/` | Принципы кадра: Rule of thirds, Centered symmetric, Leading lines, Frame within frame, Negative space minimalist, Diagonal dynamic, Triangle, Golden ratio, Pattern repetition, Foreground depth | ~10 |
| `pose/` | Позы и выражения: Frontal neutral, 3/4 confident, Hand on hip, Walking dynamic, Sitting casual/formal, Leaning wall, Hands in pockets, Looking off-camera, Looking down candid, Laughing, Serious editorial, Movement caught, Power pose, Vulnerable open | ~18 |
| `style/` | Эстетика: Clean ecommerce (Wildberries/Amazon), Luxury ecommerce (Net-A-Porter), Editorial Vogue, Editorial gritty (i-D), Personal brand creative/corporate, Portfolio classic, Product artistic minimalist/moody, Lifestyle bright, UGC raw/polished, Beauty glamour/natural, Streetwear urban, Cinematic, Vintage 70s, Y2K, Cottagecore | ~22 |
| `backdrop/` | Фоны: Pure white seamless, Black void, Light/dark grey, Beige nude, Pastel pink/blue, Earth tone terracotta, Deep blue, Forest green, Brick wall, Concrete, Wooden plank rustic, Marble luxury, Linen draped, Gradient soft, Color gel splash, Bokeh light, Mirror reflection, Plexiglass | ~20 |
| `atmosphere/` | Атмосферные модификаторы: Misty haze, Smoke ambient, Rain drops, Snow falling, Wind movement, Sunbeams god rays, Fog low ground, Confetti, Light leaks, Lens flare, Bokeh particles, Reflection, Shadow play geometric | ~13 |
| `locations/_custom/` | Пользовательские локации (создаёт юзер). Связь с asset folder в Createya через `folder_slug` в frontmatter | 0 (юзер сам) |

**Всего из коробки:** ~141 пресет.

## Формат пресета (стандарт)

```markdown
---
name: <slug-kebab-case>
type: lighting | color | camera | composition | pose | style | backdrop | atmosphere | location
display_name: <человекочитаемое название>
tags: [tag1, tag2, tag3]                    # для quick filter
fits_categories: [fashion, personal_brand]   # где работает
not_for: [ecommerce]                         # где НЕ применимо (если есть)
inject_text: |                                # текст для inject в etalon prompt (английский, ≤120 слов)
  <conjunction-ready phrase that fits into 250-word english prompt>
---

# <display_name>

## Кратко
<1-2 предложения сути на русском>

## Технические параметры
- <параметр>: <значение>
- ...

## Когда подходит
- <use case 1>
- <use case 2>

## Когда НЕ подходит
- <anti use case>

## Как читается на финальном фото
<визуальное описание результата — что юзер увидит на готовой картинке>
```

## Правила использования (для skill'а)

1. **Не используй пресет если он в `not_for` для текущей категории.** Это hard rule — даст плохой результат.
2. **Скомбинируй: 1 lighting + 1 color + 1 camera + (1 backdrop ИЛИ 1 location) + опц 1 composition + опц 1 pose + опц 1 style + опц 1 atmosphere.** Не перегружай — 5-7 пресетов это потолок, дальше начинают конфликтовать.
3. **`inject_text` пишется по-английски** — image gen модели лучше воспринимают английский. Описание для юзера на русском.
4. **При конфликте пресетов выбирай тот что специфичнее категории.** Например: для ecommerce `style/clean-ecommerce.md` бьёт общий `style/lifestyle-bright.md`.
5. **Записывай в `session.md` какие пресеты использовал** — юзер потом сможет переиспользовать тот же mix.

## Custom пресеты

Юзерские в `_custom/` папках внутри каждой категории. Skill читает их так же как starter — без различия. Только при `list` показывает: "Lighting (8 starter + 3 custom)".

Создавать через инструкцию юзеру: открыть в редакторе любой starter как референс → скопировать → сохранить в `_custom/<имя>.md`. Skill в конце успешной сессии может сам предложить: "Сохранить этот mix как пресет?".

## Связь с asset folders в Createya

Только пресеты типа `location` могут указать в frontmatter `folder_slug: <slug>` — это pointer на asset_folder в Createya. При использовании skill дёргает `mcp__createya__get_asset_folder({ slug })` и подгружает реальные фото локации как референсы для image-to-image.

Все остальные типы пресетов — чисто текстовые, на сервер не ходят.
