# Variation rules — серия после approved эталона

После того как эталон одобрен, вариации строятся по жёстким правилам. Цель: сохранить визуальный язык серии, менять только то, что явно разрешено.

## Принцип
> "Subject и одежда — неприкосновенны. Всё остальное — пространство для творчества."

Вариация — НЕ новый промт с нуля. Это точная копия subject+clothing из эталона плюс новый контекст.

## Что копируется verbatim (слово в слово)

Из approved эталона:
- **Subject block** — все 3-4 предложения описания персонажа/товара
- **Clothing block** — каждый предмет одежды/каждая деталь товара
- **Core style markers** — те же текстурные и mood-маркеры
- **Quality markers** — ровно те же (professional photography, high detail, realistic, 8K)
- **Negative constraints** — ровно те же

Нельзя перефразировать, "улучшать", сокращать. Копировать как есть.

## Что меняется в каждой вариации

| Слой | Диапазон изменений | Примеры |
|------|-------------------|---------|
| Поза / action | Полная свобода | walking mid-stride, sitting cross-legged, leaning against wall |
| Ракурс камеры | Полная свобода | 3/4 left, overhead angle, low angle ground level |
| Кадрирование | Полная свобода | waist-up crop, extreme closeup face, full body wide |
| Объектив | Полная свобода | 35mm wide, 85mm portrait, 200mm compressed |
| Локация | Только если NOT ecommerce clean | urban street, minimal interior, park |
| Освещение | Меняй стиль при смене локации | golden hour, blue hour, mixed practical lights |
| Выражение лица | Для lifestyle/fashion/ugc | candid laugh, pensive gaze, confident smirk |
| Момент действия | Lifestyle/UGC | mid-conversation, reaching for coffee, opening package |

## Структура промта вариации (250+ слов обязательно)

```
[SUBJECT VERBATIM — copy from etalon, 3-4 sentences]

[CLOTHING VERBATIM — copy from etalon, 3-4 sentences]

NEW POSE/ACTION (3-4 sentences):
<describe specific pose, body language, gesture, weight distribution, hand placement>

NEW LOCATION/ENVIRONMENT (2-3 sentences):
<setting, depth, background elements, floor/surface>

NEW LIGHTING (2 sentences):
<source direction, quality, shadows, highlights, time of day if outdoor>

NEW CAMERA & LENS (2 sentences):
Camera: <brand model>, <focal length> lens, f/<aperture>, <shutter if relevant>.
<focus point, depth of field description>

[STYLE MARKERS — same as etalon]

[QUALITY MARKERS — same as etalon]

[NEGATIVE CONSTRAINTS — same as etalon]
```

## JSON output format для batch-генерации

Skill сохраняет вариации в `creative/sessions/<id>/variations/`:

```json
{
  "variation_id": "v001",
  "etalon_id": "etalon-001",
  "session_id": "2026-05-03-brand-shoot",
  "changes": {
    "pose": "walking mid-stride, left foot forward",
    "location": "minimal white interior, concrete floor",
    "lighting": "soft diffused window light from left",
    "camera": "Sony A7R IV, 35mm f/2.8",
    "angle": "3/4 left, eye-level"
  },
  "prompt": "<full 250+ word prompt here>",
  "reference_image_urls": ["<etalon cdn url>"],
  "model_slug": "nano-banana-pro",
  "status": "pending"
}
```

После генерации поле `status` меняется на `generated`, добавляется `result_url`.

## Сколько вариаций делать

| Цель сессии | Минимум вариаций | Рекомендация |
|-------------|-----------------|--------------|
| Ecommerce листинг | 4 (front, 3/4, side, back) | 6-8 с деталями |
| Fashion editorial | 6 | 10-12 |
| UGC серия | 3 | 5-6 разных mood |
| Personal brand | 4 | 8 (corporate + creative mix) |
| Product showcase | 3 | 5-6 со сменой окружения |

## Workflow вариаций

1. Получить approval на эталон (download.sh → Read → QA → "approved" от юзера)
2. Определить количество и стратегию вариаций
3. Собрать batch: для каждой вариации — заполнить JSON, построить промт
4. `mcp__createya__run_model` с `reference_image_urls: [etalon_cdn_url]`
5. `download.sh` → `preview-grid.sh` → показать сетку юзеру
6. Юзер выбирает финалисты → `results/`

## Запрещено в вариациях

- Менять описание субъекта (другой цвет волос, другая фигура)
- Менять одежду (другой цвет, другая вещь)
- Менять бренд/логотип на товаре
- "Улучшать" quality markers — если эталон принят, не трогай
- Генерировать вариации до approval эталона

## Cross-references

- Эталон: `etalon-locked-composition.md`
- UGC-специфичные правила вариаций: `ugc-realism.md`
- Fashion вариации: `fashion-editorial.md`
- Character consistency: `character-sheet.md`
