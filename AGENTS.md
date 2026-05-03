# Agent instructions

Этот репо содержит:
1. **MCP сервер** Createya (`https://api.createya.ai/mcp`) — генерация изображений и видео через 100+ AI-моделей (FLUX, Sora 2, Veo 3.1, Kling 3.0, Nano Banana 2 и др.)
2. **Claude Code skills** в `skills/` — `createya` (базовая интеграция) и `creative-director` (AI режиссёр для фотосессий, lookbook, UGC video, character sheets)

## What this repo does

Generates AI marketing creative (images, video, character sheets) through the
Createya external API and a high-level "creative director" workflow. All API
operations go through MCP tools at `mcp__createya__*`. Local file management,
asset library, and creative-director orchestration are bash + Markdown skill
files.

## First-time setup (any agent)

```bash
# Get an API key:
open https://createya.ai/settings/api-keys

# Install the MCP server (auto-detects Claude Code, Cursor, Cline, Windsurf,
# Codex, Gemini CLI, Continue.dev, Claude Desktop):
curl -fsSL https://api.createya.ai/install-mcp | bash -s -- crya_sk_live_<your-key>
```

After that, every agent has the following MCP tools available:
- `mcp__createya__list_models` — каталог моделей с `parameters_schema`
- `mcp__createya__run_model` — запуск генерации `{ model, input }`
- `mcp__createya__get_run_status` — polling для async (видео)
- `mcp__createya__get_balance` — баланс кредитов workspace
- `mcp__createya__request_upload_url` — presigned PUT URL для upload референсов

## How agents should use this repo

### Claude Code (preferred)

Install the plugin:
```bash
/plugin install createya-mcp@createya-ai
```

This installs both the MCP server config and the `creative-director` skill.
Read `skills/creative-director/SKILL.md` first for the full workflow.

### OpenAI Codex CLI

Codex reads `AGENTS.md` in repo root (this file). Codex also supports SKILL.md
format — point Codex at `skills/creative-director/SKILL.md` for the full
creative-director workflow.

For ad-hoc generation, just ask: "use Createya MCP to generate <X>" — Codex will
call `mcp__createya__list_models` first, then `run_model`.

### Cursor / Cline / Windsurf / Continue / Gemini CLI

Skill format не поддерживается этими IDE как у Claude Code. Используй MCP tools
напрямую — они работают везде где есть MCP support. См. `docs/non-claude-agents.md`
для copy-paste промптов которые делают то же что creative-director skill, но
ручной формы.

## Universal principles (for any agent)

These apply when generating creative through this MCP, regardless of skill:

### Etalon → approval → variations
**Never** запускай batch вариаций без согласованного эталона.

1. One reference (etalon) shot first — locked composition by category
2. Download the result locally, visually inspect for QA (hands, faces, merged objects)
3. Show to user → wait for approval
4. Only then — N variations с `start_image_url` = approved etalon CDN

### UGC realism (when generating UGC content)

Каждый prompt должен содержать:
- **Imperfection block (camera)**: motion blur, slight overexposure, grain, lens distortion, off-center framing, soft focus
- **Skin realism block**: 3-4 cues — "visible pores, slight unevenness in skin tone, minor undereye shadows, hint of natural shine". **DO NOT** use acne / pimples / blemishes
- Reference order: character first → product → style refs

### Vision QA loop

После каждой генерации image — Read локальный файл, проверь:
- Hands/fingers (correct count, no distortion)
- Faces (no duplicate features, normal anatomy)
- Objects (not merged, not impossible)
- Skin (natural texture)

Max **2 retry** with refined prompt before stopping.

### Credit cost gate

Before any generation:
1. Check `logs/createya-api.jsonl` for similar past requests
2. If unknown — `mcp__createya__list_models` for `credits_per_request`
3. Show estimate to user → wait for confirmation
4. **Don't run** until "yes". Exception: QA retries (still billed).

### Reference media — always public URL

`run_model` принимает только public CDN URLs. Никогда не пытайся передать
локальный путь или base64. Use `mcp__createya__request_upload_url` или
bash `./scripts/upload.sh <file>` (если skill scripts установлены).

### Two-step for image-to-video

Cheap before expensive:
1. Nano Banana still (~18 credits) → approval
2. Then Veo 3.1 / Sora 2 / Seedance video (~60-200 credits) using approved still
   as `start_image_url`

Никогда не вали dorogое video сразу — потеряешь 100+ credits на каждой итерации.

## File map

```
.claude-plugin/manifest.json         ← Claude Code plugin manifest
server.json                          ← MCP Registry metadata
install.sh                           ← MCP installer (auto-detects 8 clients)
configs/                             ← Per-client MCP configs
docs/
  models-image.md                    ← Image model catalog
  models-video.md                    ← Video model catalog
  non-claude-agents.md               ← Workflow for Cursor/Cline/Windsurf/etc
examples/                            ← REST + MCP examples in 5 languages
skills/
  createya/SKILL.md                  ← Базовая MCP интеграция
  creative-director/                 ← AI режиссёр
    SKILL.md                         ← Decision tree + universal principles
    references/
      api-reference.md               ← Endpoints + MCP tools cheatsheet
      prompting/                     ← Formulas по сценариям
        etalon-locked-composition.md
        ugc-realism.md
        variation-rules.md
        character-sheet.md
        influencer-recreation.md
        ecommerce-clean.md
        ecommerce-luxury.md
        fashion-editorial.md
        personal-brand.md
        product-showcase.md
        product-hero.md
        product-artistic.md
        ugc-product-selfie.md
        ugc-video.md
        lifestyle-cinematic.md
        analyze-reference.md
      presets/                       ← Профессиональная библиотека пресетов
        lighting/  (24 + INDEX)
        color/     (18)
        camera/    (15)
        composition/  (10)
        pose/      (18)
        style/     (22)
        backdrop/  (20)
        atmosphere/  (13)
        locations/_custom/  (юзерские локации с pointer на asset folders в Createya)
    scripts/                         ← Bash утилиты
      setup.sh                       ← Workspace setup
      sync.sh                        ← Local → S3 sync (presigned PUT)
      upload.sh                      ← Single-file upload
      download.sh                    ← Download generation result locally
      intake.sh                      ← Drag-drop file → creative/assets/<type>/<slug>/
      preview-grid.sh                ← HTML grid превью результатов
```

## API quick reference

### `POST /v1/run`
```bash
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"nano-banana-pro","input":{"prompt":"..."}}'
```

### `POST /v1/uploads/presigned`
Get presigned PUT URL for a file. File lives in `temp/` for 24 hours, then
auto-deleted by S3 lifecycle.

```bash
curl -X POST https://api.createya.ai/v1/uploads/presigned \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"filename":"front.jpg","mime_type":"image/jpeg","size_bytes":245678}'
```

Then `PUT` raw bytes to `presigned_url` with `Content-Type` header.

### `GET /v1/balance`
```bash
curl -H "Authorization: Bearer $CREATEYA_API_KEY" https://api.createya.ai/v1/balance
```

## Key rules (do not violate)

- **Never** print or commit API keys (`.env` is in `.gitignore`)
- **Never** skip etalon approval before variations
- **Never** run video generation without first generating still and approval
- **Never** use base64 in MCP requests >30KB — use `request_upload_url` instead
- **Never** generate NSFW, violence, or recreate real celebrities
- **Always** include `prompt` field for generative models
- **Always** use enum values from `parameters_schema` exactly (case-sensitive)
- **Always** use family slug (`nano-banana-pro`, `flux-2`, `kling-video-o3-pro`) — server picks endpoint automatically by input shape

## Support

- **Docs**: https://createya.ai/api
- **Repo**: https://github.com/Createya-ai/createya-mcp
- **Issues**: https://github.com/Createya-ai/createya-mcp/issues
- **Email**: support@createya.ai
