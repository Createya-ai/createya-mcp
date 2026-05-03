# Locations — кастомные локации

Эта папка предназначена для пресетов **конкретных физических мест** — студий, лофтов, улиц и любых других пространств, в которых ты регулярно работаешь.

---

## Зачем нужны location-пресеты

Когда ты возвращаешься в знакомую локацию, Creative Director может автоматически:

- Вспомнить характер пространства, его освещение и настроение
- Порекомендовать подходящие lighting и atmosphere пресеты
- Учесть ограничения места (потолок, ширина, цвет стен, natural light)
- При наличии `folder_slug` — подтянуть реальные фотографии из Asset Library Createya для референса

---

## Структура папки

```
locations/
  README.md          ← этот файл
  _custom/           ← твои кастомные локации (создавай сам)
    loft-studio-ny.md
    outdoor-park-kolomenskoye.md
    client-apartment-5th-floor.md
```

Папка `_custom/` стартует **пустой**. Заполняй по мере работы.

---

## Формат пресета локации

Пресет локации использует тот же frontmatter + sections формат, что backdrop и atmosphere, но с `type: location`.

### Обязательные поля

```yaml
name:          # kebab-case slug (latin), уникальный
type:          location
display_name:  # читаемое название на любом языке
tags:          # [список ключевых характеристик]
fits_categories: # в каких жанрах подходит
not_for:       # для каких жанров не подходит
inject_text:   # 80-120 слов английского описания для генерации промпта
```

### Опциональное поле: `folder_slug`

```yaml
folder_slug: loft-studio-ny
```

Если указан `folder_slug`, Creative Director при работе с этой локацией вызовет:

```
mcp__createya__get_asset_folder({ slug: "loft-studio-ny" })
```

и получит реальные CDN-ссылки на твои фотографии этого места — для визуального референса при планировании съёмки.

**Как загрузить фото локации в Asset Library:**
1. Открой Createya → Asset Library
2. Создай папку с нужным slug (например `loft-studio-ny`)
3. Загрузи 3–10 референсных фото: общий план, детали, разные углы
4. Пропиши этот slug в `folder_slug` пресета

---

## Секции документа

Каждый пресет-локации содержит 5 секций на русском:

1. **Кратко** — 2-3 предложения о характере места
2. **Технические параметры** — размер, потолок, natural light, стены, ограничения
3. **Когда подходит** — жанры и задачи для этой локации
4. **Когда НЕ подходит** — ограничения и несовместимые задачи
5. **Рекомендации по свету** — какие источники работают лучше, типичные проблемы

---

## Workflow: как добавить новую локацию

### После первой съёмки в новом месте

По окончании съёмки Creative Director предложит:

> «Мы работали в новом месте. Хочешь сохранить как пресет локации?»

Если да — задаст 5-7 уточняющих вопросов и создаст файл в `locations/_custom/<slug>.md`.

### Вручную

Скопируй пример ниже, заполни по образцу и сохрани в `locations/_custom/`:

```bash
# Пример имени файла:
locations/_custom/loft-studio-spb.md
```

---

## Пример пресета локации

```markdown
---
name: loft-studio-ny
type: location
display_name: Loft Studio NY (Нью-Йорк, SoHo)
tags: [loft, industrial, brick-wall, natural-light, high-ceiling, editorial]
fits_categories: [fashion_editorial, lifestyle_urban, personal_brand_creative, streetwear]
not_for: [ecommerce_clinical, beauty_clean_white, corporate_formal]
folder_slug: loft-studio-ny
inject_text: |
  Industrial SoHo loft studio with exposed brick walls, raw concrete floors, and oversized
  north-facing windows providing consistent diffused natural daylight. 5-meter ceilings allow
  large lighting rigs. Brick wall backdrop on east side, white plaster wall on west. Open
  plan 200sqm. No air conditioning noise. Elevator access with freight door for large equipment.
  Warm industrial aesthetic with strong natural light. Ideal for editorial fashion, urban
  lifestyle, and creative personal brand photography in New York industrial loft tradition.
---

# Loft Studio NY

## Кратко
Индустриальный loft в SoHo с кирпичными стенами и потолком 5 метров. Огромные окна на север дают ровный диффузный дневной свет весь день. Универсальное editorial пространство для fashion, lifestyle и personal brand.

## Технические параметры
- **Площадь**: 200 м², open plan без перегородок
- **Потолок**: 5 м — достаточно для больших боксов, overhead рига, overhead strobe
- **Дневной свет**: северные окна 2.4 × 3.0 м × 4 штуки — ровный диффузный свет без прямого солнца
- **Стены**:
  - Восток: exposed red brick, ~12 × 5 м — готовый urban backdrop
  - Запад: белая штукатурка, чистая поверхность — white bounce или plain backdrop
  - Север/юг: стекло/окна
- **Пол**: сырой бетон, полированный; допускает водяные спреи и разливы
- **Инфраструктура**: 32A / 16A розетки, нет кондиционера (тихо для видео)
- **Доступ**: грузовой лифт — можно привезти furniture, крупные props
- **Ограничения**: нет blackout — дневной свет нельзя полностью выключить

## Когда подходит
- Fashion editorial urban — кирпич как готовый backdrop
- Lifestyle urban creative — loft aesthetic как среда
- Personal brand creative — Artists, founders, creatives
- Streetwear и urban fashion lookbook
- Behind-the-scenes и process content (дневной свет + loft = authentic)

## Когда НЕ подходит
- Ecommerce white background — нет возможности blackout, белый seamless требует доп. усилий
- Beauty clinical — need pure white controlled light; дневной спил мешает
- Corporate formal headshot — loft aesthetic слишком casual для C-suite
- Night shoot без дополнительных blackout шторок

## Рекомендации по свету
- **Утро (9–12)**: мягкий свет с севера + запада — идеально без дополнительных источников для fashion
- **День (12–16)**: ровный ambient через север — key-only setup, нет fill проблем
- **После 16**: свет слабеет — добавить 1 × Profoto B10 через большой softbox
- **Strobe setup**: 2 × large octa (120 cm+) overhead + 1 rim = универсальная editorial схема
- **Проблема**: яркие пятна от прямого south light через открытую дверь — закрывать во время съёмки
```

---

## Советы

- **Одна локация = один файл.** Не объединяй разные студии в один пресет.
- **Будь конкретен в технических параметрах** — потолок, окна, стены. Это то, что реально влияет на схему света.
- **Обновляй пресет** после каждой съёмки — замечания «сработало / не сработало» ценны для следующего раза.
- **`folder_slug` не обязателен**, но значительно улучшает работу skill'а при планировании — загрузи хотя бы 3–5 фото локации.
