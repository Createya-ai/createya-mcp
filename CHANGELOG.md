# Changelog

Все заметные изменения в этом репо документируются здесь.

Формат основан на [Keep a Changelog](https://keepachangelog.com/), версионирование по [SemVer](https://semver.org/).

## [Unreleased]

### Added
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
