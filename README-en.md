<div align="center">

<img src="assets/logo.png" alt="Createya" width="320"/>

# Createya MCP & API

### World of AI without borders.
#### Through MCP or REST. No VPN. Ruble billing.

[![MCP](https://img.shields.io/badge/MCP-2025--06--18-7C3AED?style=flat-square)](https://modelcontextprotocol.io/)
[![REST](https://img.shields.io/badge/REST-OpenAPI%203.1-3B82F6?style=flat-square)](https://api.createya.ai/v1/openapi.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)
[![No VPN](https://img.shields.io/badge/No%20VPN-required-EF4444?style=flat-square)]()

[🚀 Quickstart](#-quickstart-60-seconds) · [🤖 MCP](#-what-the-mcp-server-does) · [📡 REST](#-rest-api-without-mcp) · [🎨 Models](#-model-catalog) · [⚙️ Setup](#%EF%B8%8F-setup--pick-your-tool) · [🏢 Business](#-for-businesses) · [💬 Support](#-contact)

---

> 🇷🇺 **Russian (primary):** [README.md](README.md) — authoritative version.

**Connect Createya neural networks to your AI agent via MCP, or to your code via REST. No VPN. Ruble billing. 100 free credits on signup.**

**Two paths:**
- 🤖 **MCP** — for AI agents (Claude, Cursor, Cline, Windsurf, Codex, OpenCode). Single URL, OAuth or Bearer — agent discovers the model catalog automatically.
- 📡 **REST** — for your code. Single Bearer token, `POST /v1/run`, ready-made examples in curl / Python / Node.js / Go.

</div>

---

## 🎯 Why this exists

The era of AI agents has begun. Claude, Cursor, Cline, OpenCode, Codex — a new agent framework appears every week. They all speak **MCP** (Model Context Protocol) — Anthropic's open standard for connecting external tools.

Createya solves 5 typical problems:

| Problem | Createya solution |
|---|---|
| Geo-blocked AI services that need VPN | Direct access — no VPN required |
| International cards not accepted | Russian cards, SBP, T-Pay — ruble billing |
| Dozens of providers, dozens of keys | Single API key, single catalog |
| Data residency (Russian Federal Law 152-FZ) | All data stored locally, full compliance |
| Legal entities and B2B | Bank transfer, contract, closing documents, VAT |

All through **MCP** (for agents) or plain **REST** (for your code).

---

## ⚡ Quickstart (60 seconds)

**1. Sign up → get 100 free credits**
[createya.ai](https://createya.ai)

**2. Create API key** (format `crya_sk_live_<32hex>`)
[createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)

**3. Pick your path:**

### 🤖 Building an AI agent → MCP
```
Connect https://api.createya.ai/mcp to Claude / Cursor / Cline / Windsurf
In chat: "Generate an image via Createya — cat on the moon"
```
[→ Setup instructions for all clients](#%EF%B8%8F-setup--pick-your-tool)

### 💻 Writing your own code → REST
```bash
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{"model":"nano-banana-2","input":{"prompt":"cat on the moon"}}'
```
[→ Full examples in curl / Python / Node.js / Go](#-rest-api-without-mcp)

> 💡 **100 free credits** on signup. Top-up plans on [createya.ai](https://createya.ai).

---

## 🤖 What the MCP server does

Once connected, your agent gets **4 tools**:

| Tool | Description |
|---|---|
| 🔍 **`list_models`** | Full catalog with `parameters_schema`. Agent discovers what's available. |
| 🎨 **`run_model`** | Run generation: `{ model: <slug or family>, input: {...} }`. Image / video / audio / text. |
| ⏳ **`get_run_status`** | Poll async runs (video typically takes 30-180 seconds). |
| 💰 **`get_balance`** | Current workspace credit balance. |

**Endpoint:** `https://api.createya.ai/mcp`
**Transport:** Streamable HTTP (MCP spec 2025-06-18)
**Auth:** OAuth 2.1 (for Claude.ai) or Bearer header (everything else)

---

## ⚙️ Setup — pick your tool

### A. OAuth — easiest path (Claude Desktop / Claude.ai / Claude Code)

1. **Claude.ai** → [Settings → Connectors](https://claude.ai/settings/connectors) → **Add custom connector**
   **Claude Desktop** → `+` menu → `Connectors` → `Add custom connector`
2. Server URL: `https://api.createya.ai/mcp`
3. Claude opens Createya authorization page — paste your `crya_sk_live_...` key → **Allow**
4. Done. Tools (`list_models`, `run_model`, ...) appear in chat.

> 💡 Each team member gets their own key. Credits charged from the workspace the key belongs to.

### B. Claude Code (CLI)

```bash
claude mcp add createya "https://api.createya.ai/mcp" \
  --transport http \
  --header "Authorization: Bearer crya_sk_live_..."
```

> ⚠ Header value uses `:` (colon + space), **not** `=`. Most common mistake.

### C. Cursor

`~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project):
```json
{
  "mcpServers": {
    "createya": {
      "url": "https://api.createya.ai/mcp",
      "headers": {
        "Authorization": "Bearer crya_sk_live_..."
      }
    }
  }
}
```

### D. Cline (VS Code)

In `settings.json`:
```json
{
  "cline.mcpServers": {
    "createya": {
      "type": "streamableHttp",
      "url": "https://api.createya.ai/mcp",
      "headers": { "Authorization": "Bearer crya_sk_live_..." },
      "disabled": false
    }
  }
}
```
> Type is `streamableHttp` (camelCase, no hyphen).

### E. Windsurf

`~/.codeium/windsurf/mcp_config.json`:
```json
{
  "mcpServers": {
    "createya": {
      "serverUrl": "https://api.createya.ai/mcp",
      "headers": { "Authorization": "Bearer crya_sk_live_..." }
    }
  }
}
```

### F. Codex / OpenCode

See [`configs/codex.toml`](configs/codex.toml) and [`configs/opencode.json`](configs/opencode.json) — ready-made templates.

### G. Any other MCP client

Ready-made configs in [`configs/`](configs/). Copy the relevant one, replace `crya_sk_live_...` with your key — done.

---

## 🎨 Model catalog

Live catalog with examples (curl / Python / Node.js) at **[docs.createya.ai/models/](https://docs.createya.ai/models/)** (synced with live API weekly).

### Currently public via MCP/REST (5 endpoints)

| Model | Type | Slug | Details |
|---|---|---|---|
| **Nano Banana 2** | image | `nano-banana-2` | [docs.createya.ai/models/nano-banana-2](https://docs.createya.ai/models/nano-banana-2) |
| **Nano Banana 2 Edit** | image (i2i) | `nano-banana-2-edit` | [docs.createya.ai/models/nano-banana-2-edit](https://docs.createya.ai/models/nano-banana-2-edit) |
| **Nano Banana Pro** | image | `nano-banana-pro` | [docs.createya.ai/models/nano-banana-pro](https://docs.createya.ai/models/nano-banana-pro) |
| **GPT Image 2** | image | `gpt-image-2` | [docs.createya.ai/models/gpt-image-2](https://docs.createya.ai/models/gpt-image-2) |
| **GPT Image 2 Edit** | image (i2i) | `gpt-image-2-edit` | [docs.createya.ai/models/gpt-image-2-edit](https://docs.createya.ai/models/gpt-image-2-edit) |

### Coming soon (140+ endpoints)

We're rolling out public access to remaining families:
**FLUX 2 / Kontext** · **Sora 2** · **Veo 3.1** / Fast · **Kling Video O3 / V3 / 4K** · **Seedance 2.0** · **Happy Horse** · **Hailuo 2.3** · **Higgsfield Soul** · **Midjourney** · **Runway Gen-4** · **Recraft** · **Ideogram** · **Imagen** · **Wan** · **Grok Imagine** · **Seedream** and more.

📚 **Live catalog** via API: `GET https://api.createya.ai/v1/models` (public, no auth)
📖 **Marketing model overview:** [createya.ai/knowledge](https://createya.ai/knowledge)
📡 **API docs** + per-model pages: [docs.createya.ai](https://docs.createya.ai)

---

## 💡 Usage examples

### Generate an image

```
You: Generate an image via Createya — cat on the moon, Studio Ghibli style, 16:9
Agent: [calls createya:run_model with model=nano-banana-2]
       → returns CDN link to the image
```

[`examples/01-generate-image.md`](examples/01-generate-image.md) — more details.

### Generate a video

```
You: Take this image (URL) and animate it via Kling, 5 seconds
Agent: [calls createya:run_model with model=kling-video-o3, image_url=...]
       → returns run_id
       → after 30-60 sec: createya:get_run_status → finished video
```

[`examples/02-generate-video.md`](examples/02-generate-video.md)

### REST without MCP

- [`examples/05-rest-curl.md`](examples/05-rest-curl.md) — curl (sync + async + upload)
- [`examples/06-rest-python.md`](examples/06-rest-python.md) — Python client
- [`examples/07-rest-nodejs.md`](examples/07-rest-nodejs.md) — TypeScript / Node.js / Express / Next.js
- [`examples/08-rest-go.md`](examples/08-rest-go.md) — Go
- [`examples/09-rest-php.md`](examples/09-rest-php.md) — PHP / Laravel
- [`examples/03-async-polling.md`](examples/03-async-polling.md) — async patterns (video, retry)
- [`examples/04-upload-image.md`](examples/04-upload-image.md) — uploading for image-to-image
- [`examples/10-error-handling.md`](examples/10-error-handling.md) — 429 retry, 402, 422

---

## 📡 REST API without MCP

If you're not building an agent, just a developer — use the REST API. One Bearer token, one POST, done.

### Step 1 — get a token

1. Sign up at [createya.ai](https://createya.ai) (you get 100 free credits)
2. Go to [createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)
3. **Create new key** → name it (e.g. `my-bot-prod`) → **Create**
4. **Copy the key** — shown **once**. Format: `crya_sk_live_<32hex>`
5. Store as a password (env var, secret manager, never git)

### Step 2 — first request

```bash
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "nano-banana-2",
    "input": {
      "prompt": "cat on the moon, Studio Ghibli style",
      "aspect_ratio": "16:9"
    }
  }'
```

**Response:**
```json
{
  "run_id": "run_01HZX...",
  "status": "completed",
  "output": {
    "urls": ["https://cdn-new.createya.ai/image/profile-id/abc123.png"]
  }
}
```

### Step 3 — Python / Node.js / Go

**Python** (with `requests`):
```python
import os, requests

KEY = os.environ["CREATEYA_API_KEY"]
r = requests.post(
    "https://api.createya.ai/v1/run",
    headers={"Authorization": f"Bearer {KEY}"},
    json={"model": "nano-banana-2", "input": {"prompt": "cat on the moon"}}
)
print(r.json()["output"]["urls"][0])
```

**Node.js** (native fetch, Node 18+):
```javascript
const KEY = process.env.CREATEYA_API_KEY;
const r = await fetch("https://api.createya.ai/v1/run", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${KEY}`,
    "Content-Type": "application/json"
  },
  body: JSON.stringify({
    model: "nano-banana-2",
    input: { prompt: "cat on the moon" }
  })
});
const json = await r.json();
console.log(json.output.urls[0]);
```

**Go**:
```go
body := strings.NewReader(`{"model":"nano-banana-2","input":{"prompt":"cat on the moon"}}`)
req, _ := http.NewRequest("POST", "https://api.createya.ai/v1/run", body)
req.Header.Set("Authorization", "Bearer "+os.Getenv("CREATEYA_API_KEY"))
req.Header.Set("Content-Type", "application/json")
resp, _ := http.DefaultClient.Do(req)
```

→ Full examples: [`examples/05-rest-curl.md`](examples/05-rest-curl.md), [`examples/06-rest-python.md`](examples/06-rest-python.md), [`examples/07-rest-nodejs.md`](examples/07-rest-nodejs.md), [`examples/08-rest-go.md`](examples/08-rest-go.md), [`examples/09-rest-php.md`](examples/09-rest-php.md)

### Async runs (video, long audio)

```bash
# Step 1 — submit
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{"model":"kling-video-o3","input":{"image_url":"https://...","duration":5}}'
# → 202 Accepted, { "run_id": "run_01J2...", "status": "queued" }

# Step 2 — poll every 10 sec
curl https://api.createya.ai/v1/runs/run_01J2... \
  -H "Authorization: Bearer crya_sk_live_..."
# → { "status": "completed", "output": { "url": "https://cdn-new.createya.ai/video/..." } }
```

### All REST endpoints

| Method | URL | Description |
|---|---|---|
| `GET` | `/v1/models` | Full catalog with `parameters_schema` |
| `POST` | `/v1/run` | Run a generation |
| `GET` | `/v1/runs/{run_id}` | Async run status |
| `GET` | `/v1/balance` | Workspace credit balance |
| `POST` | `/v1/uploads` | Upload an image/video to Createya CDN (for image-to-image) |
| `GET` | `/v1/openapi.json` | OpenAPI 3.1 spec (for SDK auto-generation) |

### Machine-readable specs

- **OpenAPI 3.1**: `https://api.createya.ai/v1/openapi.json` — for auto-generating Python/TypeScript/Java/Ruby SDKs
- **llms.txt**: `https://api.createya.ai/llms.txt` — API map for AI agents
- **Full docs**: [createya.ai/api](https://createya.ai/api)

---

## 🏢 For businesses

Createya works with companies via contracts and bank transfers.

- **Bank transfer** — invoice, payment from corporate account
- **Contract + closing documents** — for accounting
- **VAT** — invoices with or without VAT, on request
- **Volume packages** — bulk discount, individual terms
- **API under load** — elevated rate limits, dedicated keys per service
- **152-FZ** — all data stored locally, full compliance with Russian personal data law
- **White-label** — Telegram bot / web under your brand on request

📩 Get terms and invoice within 1 business day: [support@createya.ai](mailto:support@createya.ai)

---

## 🔐 Security

- **API keys** — format `crya_sk_live_<32hex>`, stored hashed (bcrypt)
- **Workspace isolation** — key bound to a single workspace, can't charge another
- **OAuth 2.1 + PKCE** — for web clients (Claude.ai)
- **Rate limits** — at the key level, leak protection
- **152-FZ** — all data stored locally

Found a security issue? See [SECURITY.md](SECURITY.md).

---

## 🤝 Contributing

PRs welcome. New MCP client config / language example / typo fix — just open a PR. See [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow and style guide.

---

## 📚 Documentation

| Doc | Where |
|---|---|
| REST quickstart | [createya.ai/api/getting-started](https://createya.ai/api/getting-started) |
| Full REST spec | [createya.ai/api/rest](https://createya.ai/api/rest) |
| MCP connector | [createya.ai/api/mcp](https://createya.ai/api/mcp) |
| OpenAPI 3.1 | [api.createya.ai/v1/openapi.json](https://api.createya.ai/v1/openapi.json) |
| Model catalog | [createya.ai/knowledge](https://createya.ai/knowledge) |
| Examples in this repo | [`examples/`](examples/) |

---

## 💬 Contact

- 🌐 **Site:** [createya.ai](https://createya.ai)
- 📚 **Knowledge base:** [createya.ai/knowledge](https://createya.ai/knowledge)
- 🤖 **Telegram bot** (generation without code): [@createya_bot](https://t.me/createya_bot)
- 📧 **Support:** [support@createya.ai](mailto:support@createya.ai)
- 💼 **Partnership / Ambassadors:** [createya.ai/ambassador](https://createya.ai/ambassador)

---

## 📄 License

[MIT](LICENSE) — fork it, build on it, integrate it. Just credit us.

---

<div align="center">

**Createya — world of AI without borders. For AI agents everywhere.**

⭐ Star the repo if it helped!

</div>
