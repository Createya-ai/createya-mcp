# Workflows — index

Каждый workflow = именованный рецепт под типовую задачу. Скилл выбирает workflow на этапе **triage** (см. `reference/triage.md`), потом действует строго по инструкции внутри.

## Как пользоваться

1. **Triage** определяет режим (`still / edit / series / character / pipeline / video`)
2. **Маппинг режим → workflow** (см. таблицу ниже)
3. Открыть `workflows/<recipe>.md`, читать целиком
4. Действовать по `Цепочке генераций` файла, не отклоняясь

## Маппинг

| Triage режим | Workflow | Когда использовать |
|--------------|----------|--------------------|
| `still` | `single-shot.md` | Один кадр без серии |
| `edit` | `edit-and-iterate.md` | Правки с референсом |
| `series` (lookbook одежды) | `lookbook.md` | Модель + N образов |
| `series` (товар маркетплейс) | `product-cutout-pipeline.md` | Hero + ракурсы для ecom |
| `series` (личный бренд) | `personal-brand.md` | 1 фото клиента → N контекстов |
| `series` (UGC) | `ugc-ad.md` | Селфи-style + product |
| `series` (editorial / fashion) | `editorial-series.md` | 5–8 кадров locked aesthetic |
| `series` (multi-platform) | `multi-aspect-ad.md` | Один концепт в 5 aspect ratios |
| `character` | `character-sheet.md` | 9 ракурсов AI-персонажа (инфраструктура) |
| `video` | `cinematic-video.md` | Заготовка — пока без моделей |

## Что общего у всех workflow

1. **Continuity anchors** — что lock'ается в начале и держится до конца
2. **Hero-first** — для всех series workflow первый кадр = эталон, без approval не идём дальше
3. **`get_model_guide` обязательно** — перед каждым `run_model`
4. **Vision QA loop** — после каждой генерации `Read` файл, проверь
5. **Что НЕ меняется** — записано в `session.md` для каждой сессии

## Список файлов

- `single-shot.md` — один кадр, no hero loop
- `edit-and-iterate.md` — правки референса, минимум вопросов
- `lookbook.md` — модель + N образов
- `product-cutout-pipeline.md` — товар для маркетплейса
- `ugc-ad.md` — UGC селфи-style + product (с realism block)
- `personal-brand.md` — личный бренд, 1 → 10 контекстов
- `multi-aspect-ad.md` — один концепт в 5 форматах
- `editorial-series.md` — fashion editorial, locked aesthetic
- `character-sheet.md` — AI-персонаж, 9 ракурсов
- `cinematic-video.md` — pattern (без моделей пока)
