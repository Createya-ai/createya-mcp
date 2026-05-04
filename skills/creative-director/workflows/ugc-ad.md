# Workflow: UGC ad — селфи-style + product

**Триггер:** «UGC», «отзыв», «селфи с товаром», «как-будто блогер», «реклама от лица пользователя»

**Главное правило:** UGC — это **намеренная неидеальность**. Студийная картинка убьёт UGC-эффект. См. `references/prompting/ugc-realism.md` для обязательных блоков.

**Continuity anchors:**
- Лицо «блогера» (если серия)
- Сам продукт (always exact)

**Что меняется в серии:**
- Поза / выражение / момент
- Микро-локация (кухня → ванная → выход → улица)
- Действие с продуктом (показывает / использует / показывает результат)

## Цепочка генераций

### Шаг 1 — Эталонный UGC-кадр

**Модель:** Nano Banana 2 (NB Pro Edit если есть фото блогера И продукта)

**Промт-структура — обязательные блоки:**

```
[Описание блогера: возраст / type / casual look]
+ [Локация: bedroom / kitchen / bathroom / casual outdoor]
+ [Action with product: holding / applying / showing result]
+ [Camera: smartphone selfie OR partner-shot, eye level OR slightly above]

IMPERFECTION BLOCK (камера):
- Slight motion blur on hands or hair
- Mild overexposure on bright surfaces
- Natural lens distortion (slight wide-angle look)
- Off-center framing (subject NOT perfectly centered)
- Subtle grain matching iPhone/smartphone capture
- Soft focus on edges, sharp on subject

SKIN REALISM BLOCK (кожа):
- Visible pores at close range
- Slight unevenness in skin tone (natural, not perfect)
- Minor undereye shadows
- Hint of natural shine on T-zone

ANTI-PATTERNS — НЕ ИСПОЛЬЗОВАТЬ:
- acne, pimples, blemishes, breakouts (= person with skin problems)
- studio lighting, three-point setup, beauty dish
- magazine retouching, professional makeup application
- perfect symmetry
```

**Order референсов в `image_urls`** (если есть):
1. Лицо/блогер — first
2. Продукт — second
3. Style references (атмосфера) — last

### Шаг 2 — Approval и QA

**Vision QA UGC:**
- Свет ОДИН (естественный из окна / lamp), не студийный
- Кадр СЛЕГКА off-center или с tilt — не идеальная симметрия
- Кожа НЕ retouched — видны естественные неровности
- Продукт читается, но не доминирует

**Если кадр выглядит «студийно» / «реклама»** — retry с усиленным imperfection block. Это самый частый fail.

### Шаг 3 — Серия (если просили)

UGC-серия обычно 3 кадра в нарративе:
1. **Before / setup** — блогер берёт продукт, нейтральное лицо
2. **Action** — использует продукт, концентрация
3. **After / результат** — улыбка, satisfaction, показ результата

Каждый кадр — `image_urls=[<approved_etalon>]` + промт «same person, same outfit, same location. New action: ...»

### Шаг 4 — Видео-расширение (когда подключим)

Каждый still можно будет анимировать через image-to-video для reels/shorts:
- Шаг before → лёгкий движение головы / руки
- Шаг action → действие с продуктом
- Шаг after → улыбка / поворот головы

**Сейчас** запиши в `session.md`:
```
TODO video: ugc-01.jpg / ugc-02.jpg / ugc-03.jpg → image-to-video для reels
```

## Что спрашивать

**Обязательно:**
1. Продукт — есть фото? Куда положил?
2. Блогер — есть фото или нужно сгенерить «типаж»?
3. Локация-вайб — дом / улица / гимн / офис?
4. Один кадр или нарратив 3 кадра (before/action/after)?

**НЕ спрашивай:**
- Камера / lens — UGC = смартфон, точка
- Освещение — natural ambient
- Поза / композиция — решаешь сам по UGC-канону

## Что НЕ меняется

```
LOCKED:
- Person: <блогер reference / описание типажа>
- Product: <CDN URL продукта>
- UGC vibe (camera + skin imperfection blocks present)
- Smartphone capture aesthetic
```

## Кредиты

- 1 кадр UGC: ~10–18 cr (NB 2 / NB Pro Edit)
- Нарратив 3 кадра: ~30–55 cr

## Запрещено

- ❌ Студийный свет (three-point, softbox, beauty dish) — убьёт UGC
- ❌ Magazine retouching кожи
- ❌ Идеальный кадр строго в центре
- ❌ Делать «UGC от лица знаменитости» — только обобщённый типаж
