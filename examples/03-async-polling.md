# Пример 3 — Async-задачи и polling

Видео-модели (Kling, Sora, Veo, Seedance) работают **асинхронно**: запрос возвращается сразу с `run_id`, а сам результат готов через 30-180 секунд. Картинки и быстрые модели — обычно sync (готовый ответ сразу).

## Как отличить sync от async

Поле `mode` в `/v1/models` для каждой модели:
- `mode: "sync"` — `POST /v1/run` сразу вернёт готовый `output`
- `mode: "async"` — `POST /v1/run` вернёт `202 Accepted` + `run_id`, надо poll'ить

Можно не угадывать — наш контракт совместимый: ВСЕГДА проверяй `status` в ответе. Если `status: "completed"` — всё, забирай `output`. Если `"queued"` или `"in_progress"` — poll.

## Базовый polling (curl + jq)

```bash
#!/usr/bin/env bash
set -euo pipefail

KEY="${CREATEYA_API_KEY}"
API="https://api.createya.ai/v1"

# 1. Submit
RUN=$(curl -sS -X POST "$API/run" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"kling-video-o3","input":{"image_url":"https://cdn-new.createya.ai/.../cat.jpg","duration":5}}')

RUN_ID=$(echo "$RUN" | jq -r .run_id)
echo "Submitted: $RUN_ID"

# 2. Poll каждые 10 сек до completed/failed
while :; do
  STATUS=$(curl -sS "$API/runs/$RUN_ID" -H "Authorization: Bearer $KEY")
  STATE=$(echo "$STATUS" | jq -r .status)
  echo "  status: $STATE"
  case "$STATE" in
    completed) echo "$STATUS" | jq .output; break ;;
    failed)    echo "$STATUS" | jq .error;  exit 1 ;;
    *)         sleep 10 ;;
  esac
done
```

## Python — exponential backoff с jitter

Лучшая практика: первое опрос через 5 секунд, потом удваиваем интервал с потолком 30 сек, чтобы не давить сервер при долгих генерациях.

```python
import os, time, random, requests

KEY = os.environ["CREATEYA_API_KEY"]
API = "https://api.createya.ai/v1"
HEADERS = {"Authorization": f"Bearer {KEY}", "Content-Type": "application/json"}

def submit(model: str, input_payload: dict) -> str:
    r = requests.post(f"{API}/run", headers=HEADERS, json={"model": model, "input": input_payload})
    r.raise_for_status()
    body = r.json()
    if body["status"] == "completed":
        return body  # sync — сразу готово
    return body["run_id"]

def poll(run_id: str, max_wait_sec: int = 600) -> dict:
    """Poll с exponential backoff: 5, 10, 20, 30, 30, 30, ... сек."""
    deadline = time.monotonic() + max_wait_sec
    delay = 5
    while time.monotonic() < deadline:
        r = requests.get(f"{API}/runs/{run_id}", headers=HEADERS)
        r.raise_for_status()
        body = r.json()
        if body["status"] == "completed":
            return body
        if body["status"] == "failed":
            raise RuntimeError(f"Run failed: {body.get('error')}")
        # +/- 20% jitter чтоб клиенты не синхронизировались
        time.sleep(delay * (1 + random.uniform(-0.2, 0.2)))
        delay = min(delay * 2, 30)
    raise TimeoutError(f"Run {run_id} did not complete in {max_wait_sec}s")

# Использование
run_id_or_result = submit("kling-video-o3", {
    "image_url": "https://cdn-new.createya.ai/.../cat.jpg",
    "duration": 5
})
result = run_id_or_result if isinstance(run_id_or_result, dict) else poll(run_id_or_result)
print(result["output"]["urls"][0])
```

## TypeScript — Promise-based

```typescript
const KEY = process.env.CREATEYA_API_KEY!;
const API = "https://api.createya.ai/v1";
const headers = { "Authorization": `Bearer ${KEY}`, "Content-Type": "application/json" };

interface RunResult {
  run_id: string;
  status: "queued" | "in_progress" | "completed" | "failed";
  output?: { urls?: string[]; url?: string };
  error?: { code: string; message: string };
}

async function submit(model: string, input: Record<string, unknown>): Promise<RunResult> {
  const r = await fetch(`${API}/run`, {
    method: "POST",
    headers,
    body: JSON.stringify({ model, input })
  });
  if (!r.ok) throw new Error(`HTTP ${r.status}: ${await r.text()}`);
  return r.json();
}

async function poll(runId: string, maxWaitMs = 600_000): Promise<RunResult> {
  const deadline = Date.now() + maxWaitMs;
  let delay = 5_000;
  while (Date.now() < deadline) {
    const r = await fetch(`${API}/runs/${runId}`, { headers });
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    const body: RunResult = await r.json();
    if (body.status === "completed") return body;
    if (body.status === "failed") throw new Error(`Run failed: ${body.error?.message}`);
    const jitter = 1 + (Math.random() * 0.4 - 0.2); // ±20%
    await new Promise(res => setTimeout(res, delay * jitter));
    delay = Math.min(delay * 2, 30_000);
  }
  throw new Error(`Run ${runId} did not complete in ${maxWaitMs}ms`);
}

// Использование
const submitted = await submit("kling-video-o3", {
  image_url: "https://cdn-new.createya.ai/.../cat.jpg",
  duration: 5
});

const result = submitted.status === "completed"
  ? submitted
  : await poll(submitted.run_id);

console.log(result.output?.urls?.[0]);
```

## Что делать при `failed`

Полезные коды в `error.code`:

| Код | Что значит | Что делать |
|---|---|---|
| `upstream_error` | Провайдер вернул ошибку | Попробуй другую модель / проверь `prompt` |
| `upstream_timeout` | Провайдер не ответил за лимит | Повтори через минуту |
| `provider_unavailable` | Провайдер сейчас недоступен (502/503) | Повтори с backoff'ом |
| `model_safety_violation` | Промпт нарушает правила (NSFW и т.д.) | Перефразируй prompt |
| `invalid_input` | Параметры не подходят модели | Проверь `parameters_schema` через `/v1/models` |

## Webhook вместо polling (опционально)

Если не хочешь poll'ить, передай `webhook_url` в `/v1/run`:

```json
{
  "model": "kling-video-o3",
  "input": { "image_url": "...", "duration": 5 },
  "webhook_url": "https://your-server.example.com/createya-webhook"
}
```

Когда run завершится, мы отправим POST на твой webhook с body вида:

```json
{
  "id": "run_01J2...",
  "object": "run.completed",
  "status": "completed",
  "model": "kling-video-o3",
  "output": { "urls": ["https://cdn-new.createya.ai/video/..."] },
  "credits_used": 24
}
```

Webhook отправляется один раз. Если твой сервер вернул не-2xx — мы НЕ ретраим (по умолчанию). Используй webhook + idempotency key на своей стороне.

## См. также

- [`05-rest-curl.md`](05-rest-curl.md) — базовый sync REST
- [`10-error-handling.md`](10-error-handling.md) — полная обработка ошибок (429, 402, 422)
