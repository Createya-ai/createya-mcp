# Changelog

Все заметные изменения в этом репо документируются здесь.

Формат основан на [Keep a Changelog](https://keepachangelog.com/), версионирование по [SemVer](https://semver.org/).

## [Unreleased]

### Added — v1.1.0 (creative-director skill)

**Новый skill `creative-director`** — AI режиссёр для фотосессий, lookbook, UGC-видео, character sheets поверх существующего `createya` MCP.

**SKILL.md + references**:
- `skills/creative-director/SKILL.md` — главный entry: decision tree (16 сценариев), universal principles (этрон → одобрение → вариации, vision QA loop, UGC realism, credit cost gate, two-step image-to-video)
- `skills/creative-director/references/api-reference.md` — endpoints/MCP tools шпаргалка
- `skills/creative-director/references/prompting/` — **16 формул-сценариев**:
  `etalon-locked-composition`, `variation-rules`, `ugc-realism`, `character-sheet`,
  `influencer-recreation`, `ecommerce-clean`, `ecommerce-luxury`,
  `fashion-editorial`, `personal-brand`, `product-showcase`, `product-hero`,
  `product-artistic`, `ugc-product-selfie`, `ugc-video`, `lifestyle-cinematic`,
  `analyze-reference`

**Профессиональная библиотека пресетов** — 141 файл в 8 категориях:
- `lighting/` — 24 (studio: three-point, Rembrandt, butterfly, beauty-clamshell, split, loop, broad, short, hard-light, ring-light, strip-side, beauty-dish, tabletop-tent, edge-light-product, macro-ring-flash, high-key, low-key-chiaroscuro, colored-gels-split, practical-only; natural: window, golden-hour, blue-hour, overcast, backlight-silhouette, mixed-practical)
- `color/` — 18 (luxury-muted, vibrant-ecommerce, hi-key-clean, filmic-warm/cool, pastel-ugc, cinematic-teal-orange, bleach-bypass, B&W high/low, film grain heavy/subtle, cross-process, editorial-deep-blacks, sunset-golden, moody-dark-teal, lifestyle-natural, skin-tone-balanced)
- `camera/` — 15 (portrait 85/105mm, beauty 100mm macro, fashion 50/35mm, environmental 24mm, ultra-wide 16mm, full-body 50mm, tele compressor 135mm, telephoto 200mm, flat-lay top-down, hero low-angle, macro detail 90mm, tilt-shift miniature, close-up 85mm)
- `composition/` — 10 (rule of thirds, centered, leading lines, frame within frame, negative space, diagonal, triangle, golden ratio, pattern repetition, foreground depth)
- `pose/` — 18 (frontal neutral, 3/4 confident, hand on hip, walking, sitting casual/formal, leaning, hands in pockets, looking off/down, laughing, serious, movement caught, cross-legged, lying, touching hair, crossed arms, vulnerable)
- `style/` — 22 (clean/luxury ecommerce, editorial Vogue/gritty, personal brand creative/corporate, portfolio classic, product artistic minimalist/moody, flat-lay magazine, lifestyle bright, UGC raw/polished, beauty glamour/natural, streetwear, cinematic, documentary, vintage 70s, Y2K, cottagecore, maximalist)
- `backdrop/` — 20 (white/black seamless, grey light/dark, beige, pastel pink/blue, terracotta, deep blue, forest green, brick, concrete, wood, marble, linen, gradient, color gel, bokeh, mirror, plexiglass)
- `atmosphere/` — 13 (haze, smoke, rain, snow, wind, sunbeams, fog, confetti, light leaks, lens flare, bokeh particles, water reflection, geometric shadows)
- `locations/_custom/` + README — пустая папка для пользовательских локаций с pointer на asset folders в Createya через `folder_slug`

Каждый пресет — markdown с YAML frontmatter (`name`, `type`, `display_name`, `tags`, `fits_categories`, `not_for`, `inject_text` 80-120 слов английского) + 5 секций на русском (Кратко / Технические параметры / Когда подходит / Когда НЕ подходит / Как читается на финальном фото).

**Bash скрипты** в `skills/creative-director/scripts/`:
- `setup.sh` — interactive setup workspace в проекте юзера (`creative/`, `MASTER_CONTEXT.md`, `.env`, `.gitignore`, `logs/`). Поддерживает non-interactive run для CI.
- `sync.sh` — sync local `creative/assets/` → Createya S3 через presigned URL, sha256 dedup, auto-refresh expiring uploads
- `upload.sh` — single file upload, возвращает CDN URL на stdout
- `download.sh` — download generation result в `creative/sessions/<latest>/results/` (или явный target)
- `intake.sh` — копировать attached файл в `creative/assets/<type>/<slug>/` с auto-numbering
- `preview-grid.sh` — генерит HTML grid превью результатов сессии, открывает в браузере

**Multi-agent compatibility**:
- `AGENTS.md` — в корне репо для OpenAI Codex CLI (мост на skills/, дублирует key principles)
- `docs/non-claude-agents.md` — copy-paste промпты для Cursor / Cline / Windsurf / Continue / Gemini CLI которые дают тот же workflow что creative-director skill, но без skill format

**Server-side (требует деплой `api-gateway`)**:
- `POST /v1/uploads/presigned` — presigned PUT URL в bucket `createya/temp/<user>/...`, файл живёт 24 часа, потом auto-delete через S3 lifecycle policy. Лимит 50MB, allowed mime: image/* + video/{mp4,quicktime,webm} + audio/{mpeg,wav,ogg,mp4}. Folder hint поддерживается. user_id из auth — нельзя инжектнуть чужой prefix.
- MCP tool `request_upload_url` — JSON-RPC обёртка над тем же endpoint

**CI/CD**:
- `.github/workflows/ci.yml` — на PR: validate manifest.json + server.json + per-client configs, shellcheck для bash-скриптов, проверка что API keys не в коде, проверка что все skill paths из manifest существуют, валидация frontmatter каждого пресета (required fields), markdown lint (warnings)

**Manifest update**:
- `.claude-plugin/manifest.json` — version bump 1.0.0 → 1.1.0, `creative-director` skill добавлен в `skills[]`, description расширено

### Architecture decision

Выбрана **гибридная архитектура** с разделением ролей:
- **MCP** — все API-операции (`mcp__createya__list_models`, `run_model`, `get_run_status`, `get_balance`, `request_upload_url`)
- **Bash скрипты** — I/O с локальной FS (sync, upload, download, intake, preview)
- **Skill** — оркестрация: decision tree, prompt formulas, presets, vision QA, state management
- **Локальная папка `creative/`** — главный UX (юзер видит файлы в Finder, drag-drop в чат для intake)

Vision генерится **локально через Claude Read** (нативная multimodal vision у юзера в подписке), не серверным Gemini Flash worker'ом — экономия для нас и для юзера.

S3 storage **ephemeral** (24h auto-delete) — мы не раздуваем хранилище, оригиналы у юзера локально.

### Added — предыдущая v1.0.x docs work

- `SECURITY.md` — security policy с responsible disclosure flow (RU + EN)
- `CONTRIBUTING.md` — guideline'ы для PR (новые конфиги, примеры, переводы)
- `.github/ISSUE_TEMPLATE/` — шаблоны для bug-репортов, feature-запросов, model-запросов
- `examples/03-async-polling.md` — async pattern с exponential backoff (Python + TS + curl)
- `examples/04-upload-image.md` — `/v1/uploads` для image-to-image
- `examples/08-rest-go.md` — Go клиент без зависимостей
- `examples/09-rest-php.md` — PHP / Laravel / Symfony
- `examples/10-error-handling.md` — обработка всех error.code, retry pattern, rate-limit headers
- Расширенный `README-en.md` — паритет с русской версией для international audience

### Changed
- `README.md` — добавлены ссылки на новые примеры

## [1.0.0] — 2026-04

Первый публичный релиз.

### Added
- `README.md` — полное описание Createya MCP & API (RU)
- `README-en.md` — английская версия (короткая)
- `LICENSE` — MIT
- `install.sh` — установщик skill для Claude Code (`curl -fsSL ... | bash`)
- `.claude-plugin/manifest.json` — Claude Code plugin manifest с MCP-конфигом
- `skills/createya/SKILL.md` — Claude skill для авто-discovery
- Конфиги для 6 MCP-клиентов в `configs/`:
  - `claude-desktop.json`
  - `cline.json`
  - `codex.toml`
  - `cursor.json`
  - `opencode.json`
  - `windsurf.json`
- Примеры в `examples/`:
  - `01-generate-image.md`
  - `02-generate-video.md`
  - `05-rest-curl.md`
  - `06-rest-python.md`
  - `07-rest-nodejs.md`
- `.github/workflows/sync-models.yml` — еженедельная синхронизация каталога моделей
- Brand assets в `assets/` (logo, favicon, og-image)

### Server-side (api.createya.ai)
- MCP-эндпоинт `https://api.createya.ai/mcp` (Streamable HTTP, MCP spec 2025-06-18)
- REST API `/v1/run`, `/v1/models`, `/v1/runs/{id}`, `/v1/balance`, `/v1/uploads`, `/v1/openapi.json`
- OAuth 2.1 + PKCE для Claude.ai / Claude Desktop
- Bearer auth для Cursor / Cline / Windsurf / Codex / OpenCode / curl
- 4 MCP-tools: `list_models`, `run_model`, `get_run_status`, `get_balance`
- Изоляция api-gateway в отдельный контейнер (CRE-339): DDoS на api не валит остальной Supabase
- Anon rate-limit 120 r/min/IP на публичных эндпоинтах
- Concurrency-limit на `/v1/run` от тарифа

[Unreleased]: https://github.com/Createya-ai/createya-mcp/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Createya-ai/createya-mcp/releases/tag/v1.0.0
