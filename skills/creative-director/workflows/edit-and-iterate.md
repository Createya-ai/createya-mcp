# Workflow: Edit & iterate — правки референса

**Триггер:** «измени», «убери», «добавь», «помести в», «замени», «поменяй» + есть фото
**Также:** «вырежи фон», «удали человека», «помести меня в офис», «сделай этот кадр night-time»

**Главное правило edit-моделей:** описывай **что должно сохраниться** так же тщательно как и **что меняется**. Без этого модель меняет лишнее.

## Цепочка

### Шаг 0 — Reference-first analysis

**Перед любым вопросом** — `Read` файл референса:
1. Что на изображении (субъект / композиция / свет / палитра)
2. Что хочет юзер изменить (из текста)
3. Что должно остаться

Сформулируй для себя:
```
SOURCE: [что вижу на референсе — 2-3 предложения]
CHANGE: [что меняем — точно, без лишнего]
KEEP: [что критично сохранить — лицо / поза / свет / etc]
```

### Шаг 1 — Уточнение (1 вопрос максимум)

Если в брифе **что менять** не на 100% ясно — задай ОДИН точный вопрос. Примеры:

- «Помести в офис» → «Какой office vibe — modern loft с панорамными окнами / classic wood-panel / startup open-space?»
- «Убери человека» → молча убирай, не спрашивай
- «Сделай вечером» → молча делай golden hour OR ask «golden hour or full night?» если время суток critical

Если ясно — **молча работай**, без вопросов.

### Шаг 2 — Модель

Edit-модели в Createya (порядок предпочтения):

1. **Nano Banana Pro Edit** — лучший на людях, точечные правки лица
2. **GPT Image 2 Edit** — лучший на тексте, бюджетный
3. **Flux Kontext** — структурные правки, mask-aware

Выбор обычно очевиден из задачи — **не задавай вопрос юзеру про модель если очевидно**:
- Лицо/тело меняем → NB Pro Edit
- Текст в кадре меняем → GPT Image 2 Edit
- Сцена меняется глобально → NB Pro Edit или Flux Kontext

### Шаг 3 — Промт (структура)

Из `get_model_guide(nano-banana-pro)` skeleton:
```
[Что изменить] + [Что сохранить без изменений] + [Результирующий контекст/сцена]
```

Применение:
```
[CHANGE]: Modify only [X]. [Конкретная правка].
[KEEP]: Preserve exact face, pose, body, clothing, lighting direction, color palette.
[CONTEXT]: Final result should look as if [результат] was shot in the same session as the original.
Avoid: changing facial features, altering body proportions, drifting color profile.
```

Для **multi-image edit** (например помести человека из image_1 в локацию из image_2):
```
Using image_1 (subject: [описание]) and image_2 (background/scene: [описание]):
Place the subject from image_1 into the scene from image_2.
Match lighting from image_2 onto the subject.
Keep facial features and clothing from image_1 EXACT.
Add: [optional new elements] that fit the scene naturally.
```

### Шаг 4 — Генерация и QA

`run_model` → download → `Read` → проверь:
- ✅ Изменилось то что просили
- ✅ НЕ изменилось то что должно было остаться (лицо / поза / etc)
- ✅ Финальный кадр выглядит как **один shot**, не collage

**Самый частый fail edit-моделей** — модель меняет лицо «в духе нового контекста» (например помещаешь в офис → лицо стало чуть моложе / serious-er). Если так — retry с усиленным «KEEP face IDENTICAL — same age, same expression, same micro-features».

### Шаг 5 — Итерации

Если что-то не так — короткая команда + ре-edit. См. словарик в `single-shot.md`.

**Лимит:** 3 итерации. Если после 3 не попадает — ошибка в постановке задачи, обсуди с юзером.

## Особые кейсы

### Удаление объектов

**Anti-pattern:** «удали машину» → модель часто оставляет дыру
**Лучше:** «Replace the car with empty street pavement matching the existing surface texture and lighting»

### Background removal (пока utility нет)

«Remove background, place subject on transparent / pure white seamless backdrop. Keep subject edges crisp, preserve hair detail.»

После — юзер сам сохранит как PNG и обработает в дизайне.

### Помещение нескольких объектов

`image_urls = [subject1_url, subject2_url, location_url]`

Промт:
```
Compose a single photograph using:
- image_1: [subject 1 — что взять]
- image_2: [subject 2 — что взять]
- image_3: [scene — куда поместить]

Place [subject 1] [position] and [subject 2] [position] within the scene.
Match the lighting of image_3 onto both subjects.
Keep facial features and clothing from images 1 and 2 EXACT.
Result should look like one cohesive shot.
```

### Изменение времени суток / погоды

```
Same scene, same composition, same subject position.
Change time/weather to: [target — sunset / blue hour / rain / snow / fog].
Adjust lighting accordingly: [warm low sun / cool ambient / wet reflective surfaces / etc].
Keep subject identity EXACT.
```

## Что спрашивать

**Обычно — НИЧЕГО** (помимо одного уточнения). Edit — это про скорость. Слишком много вопросов = противоречит сути edit.

**Исключения** — спросить только если:
- Не понятно какой именно объект убрать (если их несколько похожих)
- Не понятен target style (modern / vintage / etc)
- Не понятна интенсивность правки (subtle / dramatic)

## Что НЕ меняется

```
LOCKED:
- Source image as anchor (pinned in image_urls)
- Все элементы НЕ упомянутые в CHANGE
- Цветовой профиль (если правка локальная)
- Stylistic identity (если не просили сменить стиль)
```

## Кредиты

- 1 edit на NB Pro Edit: ~18 cr
- 1 edit на GPT Image 2 Edit: ~2 cr
- Итерации: 1× за каждую

## Анти-паттерны

- ❌ Описывать только что менять — модель меняет лишнее
- ❌ Длинный неструктурированный промт — модель теряет приоритеты
- ❌ Опрашивать юзера если задача ясна (edit = скорость)
- ❌ Переключаться между моделями каждую итерацию — зафиксируй одну
