# Пример 4 — Загрузка изображения для image-to-image

Многие модели принимают `image_url` (Kling Video, Nano Banana Edit, Flux Kontext, и т.д.). Вместо того чтобы выкладывать картинку на свой CDN — можно залить её прямо в Createya через `/v1/uploads`, получить URL и сразу использовать.

## Когда нужен upload

| Источник картинки | Что делать |
|---|---|
| URL уже публичный (Imgur, S3, CDN) | Передай `image_url` напрямую, upload не нужен |
| Локальный файл / blob в браузере | Загрузить через `/v1/uploads` → получить CDN URL |
| Из другого API (Telegram bot, Discord) | Скачать → загрузить через `/v1/uploads` |

## Как работает `/v1/uploads`

`POST https://api.createya.ai/v1/uploads`

Принимает multipart/form-data **или** JSON с base64. Возвращает `{ url, expires_at }` — ссылка на наш CDN, готовая к использованию в `image_url`.

**Ограничения:**
- Максимум 50 MB
- Поддерживаемые форматы: PNG, JPG, JPEG, WebP, MP4 (для video-to-video)
- TTL: 7 дней (потом удалится автоматически если не использовалась)
- Списания нет — uploads бесплатны

## Curl — multipart

```bash
KEY="${CREATEYA_API_KEY}"

# Из файла
URL=$(curl -sS -X POST "https://api.createya.ai/v1/uploads" \
  -H "Authorization: Bearer $KEY" \
  -F "file=@/path/to/cat.jpg" \
  | jq -r .url)

echo "Uploaded: $URL"

# Использовать в run_model
curl -X POST "https://api.createya.ai/v1/run" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"nano-banana-2-edit\",\"input\":{\"prompt\":\"в стиле Van Gogh\",\"image_url\":\"$URL\"}}"
```

## Curl — base64 JSON (если multipart неудобен)

```bash
B64=$(base64 -i /path/to/cat.jpg)

URL=$(curl -sS -X POST "https://api.createya.ai/v1/uploads" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d "{\"data\":\"data:image/jpeg;base64,$B64\",\"mime_type\":\"image/jpeg\"}" \
  | jq -r .url)
```

## Python

```python
import os, requests

KEY = os.environ["CREATEYA_API_KEY"]
HEADERS_BEARER = {"Authorization": f"Bearer {KEY}"}

def upload(filepath: str) -> str:
    """Загрузить локальный файл, вернуть public CDN URL."""
    with open(filepath, "rb") as f:
        r = requests.post(
            "https://api.createya.ai/v1/uploads",
            headers=HEADERS_BEARER,
            files={"file": (os.path.basename(filepath), f, "image/jpeg")},
        )
    r.raise_for_status()
    return r.json()["url"]

def upload_bytes(data: bytes, mime: str = "image/jpeg") -> str:
    """Загрузить из памяти (например после PIL.Image.tobytes())."""
    r = requests.post(
        "https://api.createya.ai/v1/uploads",
        headers=HEADERS_BEARER,
        files={"file": ("image", data, mime)},
    )
    r.raise_for_status()
    return r.json()["url"]

# Использование
image_url = upload("/Users/me/Desktop/cat.jpg")

result = requests.post(
    "https://api.createya.ai/v1/run",
    headers={**HEADERS_BEARER, "Content-Type": "application/json"},
    json={
        "model": "nano-banana-2-edit",
        "input": {"prompt": "в стиле Van Gogh", "image_url": image_url}
    }
).json()

print(result["output"]["urls"][0])
```

## TypeScript / Node.js

```typescript
import fs from "node:fs";
import path from "node:path";

const KEY = process.env.CREATEYA_API_KEY!;
const API = "https://api.createya.ai/v1";

async function uploadFile(filepath: string): Promise<string> {
  const file = fs.readFileSync(filepath);
  const blob = new Blob([file], { type: "image/jpeg" });

  const form = new FormData();
  form.append("file", blob, path.basename(filepath));

  const r = await fetch(`${API}/uploads`, {
    method: "POST",
    headers: { "Authorization": `Bearer ${KEY}` },
    body: form,
  });
  if (!r.ok) throw new Error(`upload failed: HTTP ${r.status}`);
  const json = await r.json() as { url: string };
  return json.url;
}

// Использование
const imageUrl = await uploadFile("/path/to/cat.jpg");

const r = await fetch(`${API}/run`, {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    model: "nano-banana-2-edit",
    input: { prompt: "в стиле Van Gogh", image_url: imageUrl },
  }),
});
const result = await r.json();
console.log(result.output.urls[0]);
```

## Browser — загрузка из `<input type="file">`

```typescript
async function uploadFromBrowser(file: File, apiKey: string): Promise<string> {
  const form = new FormData();
  form.append("file", file);

  const r = await fetch("https://api.createya.ai/v1/uploads", {
    method: "POST",
    headers: { "Authorization": `Bearer ${apiKey}` },
    body: form,
  });
  if (!r.ok) throw new Error("upload failed");
  const { url } = await r.json();
  return url;
}

// В обработчике <input type="file" onChange={...}>
const file = event.target.files![0];
const cdnUrl = await uploadFromBrowser(file, USER_API_KEY);
```

> ⚠ Не вшивай ключ в frontend код для production. Используй прокси на своём backend, который держит ключ серверно.

## CDN URL — что внутри

Возвращаемый URL вида `https://cdn-new.createya.ai/input/<profile_id>/<uuid>.<ext>`. Особенности:

- **Доступен публично** — любой кто знает URL может скачать (URL уникальный uuid)
- **TTL: 7 дней** для unused. После использования в run остаётся постоянно
- **CDN-кэшируется** — провайдеры (fal.ai, Kling) могут кэшировать у себя ещё на 24-72ч
- **Привязан к workspace** — другие юзеры workspace тоже видят этот URL в логах

## Связанные примеры

- [`05-rest-curl.md`](05-rest-curl.md) — все REST-эндпоинты
- [`02-generate-video.md`](02-generate-video.md) — image-to-video flow с upload
- [`10-error-handling.md`](10-error-handling.md) — обработка ошибок
