---
name: createya
description: Createya MCP integration — run AI image and video generation models through a single MCP endpoint at api.createya.ai/mcp. Direct access without VPN, ruble billing, free credits on signup. Use when user asks to generate image or video via Createya, says "сгенерируй / сгенерь через Createya", "Создаю", references Createya API/MCP, or mentions models hosted on Createya (FLUX 2, Flux Kontext, Nano Banana 2, GPT Image 2.0, Kling Image O3, Higgsfield Soul, Midjourney, Grok Imagine, Runway Gen-4, Sora 2, Seedance 2.0, Happy Horse, Veo 3.1, Kling Video O3/V3/4K).
---

# Createya MCP skill

Createya is an AI-platform that aggregates many AI image and video generation models under a single API key with single MCP endpoint. Direct access without VPN, billing in rubles. Free credits on signup.

> Currently supported via MCP/REST: **image** and **video**. Audio and text models are on the roadmap.

## When to trigger this skill

- User says "сгенерируй / создай / сгенерь картинку или видео через Createya"
- User mentions specific models hosted on Createya: FLUX 2, Flux Kontext, Nano Banana 2, GPT Image 2.0, Kling Image O3, Higgsfield Soul, Midjourney, Grok Imagine, Runway Gen-4, Sora 2, Seedance 2.0, Happy Horse, Veo 3.1, Kling Video V3 / O3 / 4K
- User wants AI without VPN, with ruble billing
- User mentions `createya.ai`, `crya_sk_live_`, или `https://api.createya.ai/mcp`

## How to use

### 1. Check connection

If `createya:list_models` tool is available — proceed. If not — point user to setup:

```
1. Register at https://createya.ai (free credits on signup)
2. Create API key at https://createya.ai/settings/api-keys (must start with crya_sk_live_)
3. Add MCP to your client (see configs/ folder in this repo)
```

### 2. List models first

Always call `createya:list_models` first if you're unsure which model fits. The full live catalog is also at https://createya.ai/knowledge.

```json
{
  "families": [
    { "slug": "nano-banana-2", "category": "image", "modes": ["text-to-image", "image-to-image"] },
    { "slug": "kling-video-o3", "category": "video", "modes": ["text-to-video", "image-to-video", "first-last-frame"] },
    ...
  ]
}
```

### 3. Run a model

```
createya:run_model({
  model: "nano-banana-2",      // family slug — server auto-picks endpoint by input
  input: {
    prompt: "кот на луне в стиле Studio Ghibli",
    aspect_ratio: "16:9"
  }
})
```

**Sync vs async** — depends on the model. Sync returns `output` immediately. Async returns `run_id` — poll via `createya:get_run_status({ run_id })` until `status: "completed"`.

**Family routing** — if you pass family slug (e.g. `kling-video-o3`), server picks endpoint based on input shape:
- `start_image_url` + `end_image_url` → `first-last-frame`
- `image_url` → `image-to-video`
- `prompt` only → `text-to-video`

### 4. Check balance with `get_balance` if needed

```
createya:get_balance() → { credits: <число>, workspace: "personal" }
```

If user is about to do an expensive operation and balance is low — warn them and link to https://createya.ai for top-up.

### 5. Always show the result URL

After `run_model` completes (sync) or `get_run_status` returns `completed`:
- Output is at `output.urls[0]` (or `output.url` for single-output models)
- URL is a public CDN link
- Show it as markdown image/video preview if possible

## Recommended models by use-case

Based on Createya's published knowledge base — full catalog at https://createya.ai/knowledge.

| User wants | Recommend |
|---|---|
| Универсальная картинка | `nano-banana-2`, `gpt-image-2-0` |
| Топ фотореализм / лица | `flux-2`, `flux-kontext` |
| Photorealism + people | `kling-image-o3` |
| Cinematic / стиль | `higgsfield-soul`, `midjourney` |
| Свежий xAI | `grok-imagine` |
| Видео OpenAI | `sora-2` |
| Видео Google | `veo` (3.1) или `veo-fast` |
| Видео Kling | `kling-video-o3`, `kling-video-v3`, `kling-video-4k` |
| Видео ByteDance | `seedance-2-0`, `seedance` (1.5) |
| Реалистичные сцены | `happy-horse` |

> 💡 Если не уверен — всегда вызывай `list_models` сначала, не угадывай slug.

## Common issues

- **401 Unauthorized** → ключ невалиден / истёк / не `crya_sk_live_*` префикс
- **402 Insufficient credits** → пополнить на https://createya.ai
- **404 Model not found** → проверь slug через `list_models`
- **422 Invalid input** → проверь `parameters_schema` модели через `list_models`
- **Async зависла** → проверь через `get_run_status`, иногда задача падает — повтори запрос

## Docs

- Site: https://createya.ai
- Knowledge base: https://createya.ai/knowledge
- API docs: https://createya.ai/api
- This repo: https://github.com/Createya-ai/createya-mcp
- Support: support@createya.ai
