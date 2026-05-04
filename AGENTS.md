# Agent instructions — Createya MCP

## What this repo is

- **MCP server** at `https://api.createya.ai/mcp` — 100+ AI generation models (FLUX, Kling, Runway, Sora 2, Veo 3.1, Midjourney, Higgsfield, Seedance, Nano Banana and more)
- **Skills** in `skills/` — `createya` (base MCP integration) and `creative-director` (AI creative director for photo shoots, lookbooks, UGC, character sheets)

---

## Setup — one command

```bash
curl -fsSL https://api.createya.ai/install | bash -s -- crya_sk_live_YOUR_KEY
```

**Get a key first:** https://createya.ai/settings/api-keys (format: `crya_sk_live_<32hex>`)

This single command:
1. Installs `createya` and `creative-director` skills for your agent
2. Registers the MCP server with your API key
3. Auto-detects your agent type (Claude Code, Cursor, Codex, OpenClaw)

**After install, restart your agent.** MCP tools and skills are immediately available.

### What gets installed per agent

| Agent | MCP registered | Skills |
|---|---|---|
| Claude Code | ✅ `claude mcp add` | ✅ `~/.claude/skills/` |
| OpenAI Codex | — | ✅ `~/.codex/skills/` + `AGENTS.md` |
| Cursor | — | ✅ `~/.cursor/skills/` |
| OpenClaw | — | ✅ `~/.openclaw/workspace/skills/` |
| Cline / Windsurf / Continue | — | See `configs/` for manual JSON snippets |

For Cline, Windsurf, or Continue — copy the relevant config from `configs/` and add your key.

---

## MCP tools available after install

| Tool | What it does |
|---|---|
| `mcp__createya__list_models` | Full model catalog with `parameters_schema` |
| `mcp__createya__run_model` | Run generation: `{ model, input }` |
| `mcp__createya__get_run_status` | Poll async job status (video: 30–180s) |
| `mcp__createya__get_balance` | Current credit balance |
| `mcp__createya__request_upload_url` | Presigned PUT URL for image/video upload |

Quick test after install:
```
List available Createya models
Generate an image: a cat on the moon, 16:9
```

---

## Creative Director skill

Read `skills/creative-director/SKILL.md` for the full workflow. Core principle:

```
ETALON (one locked shot) → user approval → VARIATIONS from etalon
```

Never run batch variations without an approved etalon. All variations use `start_image_url = <etalon CDN URL>`.

---

## Key rules

- **Never** skip etalon approval before variations
- **Never** run video generation without an approved still first
- **Never** pass local paths or base64 >30KB to `run_model` — use `request_upload_url`
- **Always** check `mcp__createya__get_balance` before expensive jobs (video: 60–200 credits)
- **Always** use exact enum values from `parameters_schema` (case-sensitive)
- **Always** use family slugs (`nano-banana-pro`, `flux-2`, `kling-video-o3`) — server picks the right endpoint

---

## File map

```
.claude-plugin/manifest.json         ← Claude Code plugin manifest
server.json                          ← MCP Registry metadata
install.sh                           ← Universal installer (served at api.createya.ai/install)
configs/                             ← Per-client MCP JSON configs (Cline, Windsurf, Cursor, etc.)
docs/
  models-image.md                    ← Image model catalog
  models-video.md                    ← Video model catalog
examples/                            ← REST + MCP usage examples (curl, Python, Node.js, Go)
skills/
  createya/SKILL.md                  ← Base MCP integration skill
  creative-director/
    SKILL.md                         ← Creative director decision tree + principles
    references/
      api-reference.md               ← MCP tools + endpoints cheatsheet
      prompting/                     ← Prompt formulas by scenario
    presets/                         ← Lighting, color, camera, pose, style presets
    scripts/                         ← Bash utilities (upload, download, workspace setup)
```

---

## REST API quick reference

```bash
# Generate image
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer $CREATEYA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"nano-banana-pro","input":{"prompt":"...","aspect_ratio":"16:9"}}'

# Check async job (video)
curl https://api.createya.ai/v1/runs/{run_id} \
  -H "Authorization: Bearer $CREATEYA_API_KEY"

# Balance
curl https://api.createya.ai/v1/balance \
  -H "Authorization: Bearer $CREATEYA_API_KEY"
```

Full OpenAPI spec: https://api.createya.ai/v1/openapi.json
llms.txt: https://api.createya.ai/llms.txt

---

## Support

- Docs: https://createya.ai/api
- Issues: https://github.com/Createya-ai/createya-mcp/issues
- Email: support@createya.ai
