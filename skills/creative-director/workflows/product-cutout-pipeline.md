# Workflow: Product cutout pipeline — товар для маркетплейса

**Триггер:** «карточка товара», «WB / Ozon фото», «hero + ракурсы», «фото товара для каталога», «ecommerce фото»

**Continuity anchors (что lock'ается):**
- Сам товар (форма / цвет / материал / лейбл / детали)
- Освещение (одно по всей серии)
- Tonality (один цвет фона, или градиент в одной палитре)

**Что меняется:**
- Ракурс (front / 3q / side / back / top-down)
- Кадрирование (full / detail / macro)
- Иногда фон (white → infographic → lifestyle)

## Цепочка генераций

### Шаг 1 — Эталонный hero shot

**Модель:** Nano Banana 2 или NB Pro Edit (если есть фото товара)

**Если есть фото товара** → `image_urls=[<product_cdn>]` + промт:
```
Hero ecommerce shot of [продукт] from the reference image.
Front three-quarter angle, centered composition.
Pure white seamless background.
Soft directional studio light from upper-left, gentle shadow grounding the product.
Crisp material rendering: [материал — matte plastic / brushed metal / glossy ceramic / soft fabric].
Sharp focus throughout. Clean, commercial, premium.
Avoid: warped geometry, label distortion, extra props, fingerprints, color shift.
```

**Если фото нет** → text-to-image. Юзер описывает товар максимально подробно (материал, цвет, размер).

**Vision QA:**
- Геометрия не искажена (бутылка не покосилась, etc)
- Лейбл читается (если есть)
- Material соответствует описанию
- Тень правильная (одно направление, мягкая)

### Шаг 2 — Approval

Открыть → ждать одобрения. Без approval не идём к ракурсам.

### Шаг 3 — Серия ракурсов

Стандартный набор для маркетплейса (5 кадров):
1. **Hero (front 3q)** — главное фото, уже есть
2. **Front straight** — строго анфас, для Lifecycle preview
3. **Side / профиль** — показать форму
4. **Back** — показать обратную сторону / лейбл
5. **Detail / macro** — текстура / fine details / логотип

Для каждого:
- `image_urls = [<approved_etalon_cdn>]`
- Промт: `Same product, same lighting, same background. New angle: [angle]. Keep: [material / color / label]. Show: [что важно в этом ракурсе]`

### Шаг 4 (опционально) — Lifestyle composite

Если юзер хочет «товар в среде» (на столе / в руке / в интерьере):
- `image_urls = [<approved_hero>]` + опционально фото локации
- Промт: `Take the product from image 1 and place it [on / in / among] [scene]. Keep product geometry, color, and material exact. Add natural environmental lighting that matches the scene.`

## Что спрашивать

**Обязательно:**
1. Есть ли фото товара? (Если да — intake → CDN URL)
2. Сколько ракурсов нужно? (1 hero / 3 / 5 стандарт / 8 max)
3. Куда продаём? (WB / Ozon / amazon / свой сайт / каталог) — влияет на aspect ratio и фон

**Опционально:**
- Бренд-цвета (если хочет на цветном фоне а не белом)
- Lifestyle-фон желателен или достаточно cutout

**НЕ спрашивай:**
- Камера / lens — решаешь сам
- Освещение — soft directional studio по умолчанию для ecom
- Поза / композиция

## Что НЕ меняется

```
LOCKED:
- Product: [название + slug ассета]
- Lighting: soft directional studio, upper-left
- Background tone: pure white / [HEX если бренд]
- Color profile: neutral, true-to-life
```

## Кредиты

- Hero: 1× (NB 2 = ~10 cr, NB Pro = ~18 cr)
- Каждый ракурс: 1×
- Серия из 5 на NB 2 = ~50 cr, на NB Pro = ~90 cr
- Lifestyle composite: 1× (но обычно требует 2–3 итерации)

Без upscale — современные модели сразу выдают разрешение под маркетплейсы. Если юзер просит upscale — объясни что не нужно для веб, нужно только для печати >A3.

## Анти-паттерны

- ❌ НЕ делать «hero shot товара на ярком цветном фоне» по дефолту — для маркетплейса = white seamless
- ❌ НЕ добавлять props если юзер не просил (extra coffee cups, plants, гаджеты в кадре)
- ❌ НЕ менять угол падения света между ракурсами — единое освещение
- ❌ НЕ обрезать в стандартный квадрат до того как юзер выбрал aspect — у WB одни требования, у Ozon другие
