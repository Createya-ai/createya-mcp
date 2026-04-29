# Пример 7 — REST API на Node.js / TypeScript

Без зависимостей — нативный `fetch` (Node 18+). Готовый клиент для копирования.

## Минимальный клиент (TypeScript)

```typescript
const BASE = "https://api.createya.ai/v1";
const KEY = process.env.CREATEYA_API_KEY!;   // crya_sk_live_...

function headers(extra: Record<string, string> = {}): Record<string, string> {
  return { "Authorization": `Bearer ${KEY}`, "Content-Type": "application/json", ...extra };
}

interface RunResult {
  run_id: string;
  status: "queued" | "processing" | "completed" | "failed";
  output?: { url?: string; urls?: string[]; text?: string };
  error?: { code: string; message: string };
}

export async function run(model: string, input: Record<string, unknown>): Promise<RunResult> {
  const r = await fetch(`${BASE}/run`, {
    method: "POST",
    headers: headers(),
    body: JSON.stringify({ model, input })
  });
  if (!r.ok) throw new Error(`${r.status}: ${await r.text()}`);
  const data: RunResult = await r.json();

  // Sync — готово сразу
  if (data.status === "completed" || data.status === "failed") return data;

  // Async — polling
  return pollRun(data.run_id);
}

async function pollRun(runId: string, intervalMs = 10_000, timeoutMs = 300_000): Promise<RunResult> {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    await new Promise(r => setTimeout(r, intervalMs));
    const r = await fetch(`${BASE}/runs/${runId}`, { headers: headers() });
    if (!r.ok) throw new Error(`${r.status}: ${await r.text()}`);
    const data: RunResult = await r.json();
    if (data.status === "completed" || data.status === "failed") return data;
  }
  throw new Error(`Timeout after ${timeoutMs}ms for run ${runId}`);
}

export async function balance(): Promise<{ credits: number; workspace: string }> {
  const r = await fetch(`${BASE}/balance`, { headers: headers() });
  return r.json();
}

export async function models(category?: "image" | "video" | "audio" | "text"): Promise<unknown[]> {
  const r = await fetch(`${BASE}/models`, { headers: headers() });
  const data = await r.json();
  return category ? data.filter((m: { output_type: string }) => m.output_type === category) : data;
}

export async function upload(blob: Buffer | Blob, contentType = "image/jpeg"): Promise<string> {
  const r = await fetch(`${BASE}/uploads`, {
    method: "POST",
    headers: { "Authorization": `Bearer ${KEY}`, "Content-Type": contentType },
    body: blob as BodyInit
  });
  return (await r.json()).url;
}
```

## Примеры использования

### Картинка
```typescript
const result = await run("nano-banana-2", {
  prompt: "кот на луне в стиле Studio Ghibli",
  aspect_ratio: "16:9"
});
console.log(result.output?.urls?.[0]);
```

### Видео из локального файла
```typescript
import { readFile } from "node:fs/promises";

const file = await readFile("./my-cat.jpg");
const imageUrl = await upload(file);

const result = await run("kling-video-o3", {
  image_url: imageUrl,
  prompt: "smooth fur motion",
  duration: 5
});
console.log(result.output?.url);
```

### Параллель
```typescript
const prompts = ["Sunset", "Ocean", "City"];
const results = await Promise.all(
  prompts.map(p => run("nano-banana-2", { prompt: p, aspect_ratio: "16:9" }))
);
results.forEach(r => console.log(r.output?.urls?.[0]));
```

### Текст / аудио

Slug'и и параметры — узнай через `models()` или [createya.ai/v1/models](https://api.createya.ai/v1/models):

```typescript
const textModels = await models("text");
const audioModels = await models("audio");
```

### Express endpoint
```typescript
import express from "express";
import { run } from "./createya";

const app = express();
app.use(express.json());

app.post("/api/generate", async (req, res) => {
  try {
    const result = await run(req.body.model, req.body.input);
    res.json(result);
  } catch (e) {
    res.status(500).json({ error: (e as Error).message });
  }
});

app.listen(3000);
```

### Next.js Server Action
```typescript
// app/actions/generate.ts
"use server";

import { run } from "@/lib/createya";

export async function generateImage(prompt: string) {
  const result = await run("nano-banana-2", { prompt, aspect_ratio: "16:9" });
  return result.output?.urls?.[0];
}
```

## Best practices

1. **Используй env vars**: `process.env.CREATEYA_API_KEY` через `dotenv` или `.env.local` (Next.js)
2. **Retry на 429/500** — `p-retry` пакет с backoff
3. **Не блокируй UI** — async-задачи (видео) делай через job queue (BullMQ, Inngest, QStash)
4. **Webhook coming soon** — будет лучше polling
5. **Раздельные ключи** для prod/dev/staging — легче ротировать и audit'ить
