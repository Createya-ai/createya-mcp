# Пример 6 — REST API на Python

Без SDK, через стандартный `requests`. Готовые блоки для копирования.

## Установка

```bash
pip install requests
```

## Минимальный клиент

```python
import os
import time
import requests

BASE = "https://api.createya.ai/v1"
KEY = os.environ["CREATEYA_API_KEY"]   # crya_sk_live_...

def headers():
    return {"Authorization": f"Bearer {KEY}", "Content-Type": "application/json"}

def run(model: str, input_: dict) -> dict:
    """Запустить генерацию. Возвращает финальный output (sync) или после polling (async)."""
    r = requests.post(f"{BASE}/run", headers=headers(), json={"model": model, "input": input_})
    r.raise_for_status()
    data = r.json()

    # Sync — output сразу
    if data["status"] == "completed":
        return data

    # Async — polling
    run_id = data["run_id"]
    while True:
        time.sleep(10)
        s = requests.get(f"{BASE}/runs/{run_id}", headers=headers())
        s.raise_for_status()
        d = s.json()
        if d["status"] in ("completed", "failed"):
            return d

def balance() -> dict:
    r = requests.get(f"{BASE}/balance", headers=headers())
    r.raise_for_status()
    return r.json()

def models(category: str = None) -> list:
    r = requests.get(f"{BASE}/models", headers=headers())
    r.raise_for_status()
    data = r.json()
    if category:
        return [m for m in data if m["output_type"] == category]
    return data

def upload(file_path: str, content_type: str = "image/jpeg") -> str:
    with open(file_path, "rb") as f:
        r = requests.post(
            f"{BASE}/uploads",
            headers={"Authorization": f"Bearer {KEY}", "Content-Type": content_type},
            data=f.read()
        )
    r.raise_for_status()
    return r.json()["url"]
```

## Примеры использования

### Сгенерировать картинку
```python
result = run("nano-banana-2", {
    "prompt": "кот на луне в стиле Studio Ghibli",
    "aspect_ratio": "16:9"
})
print(result["output"]["urls"][0])
```

### Видео из локальной картинки
```python
image_url = upload("./my-cat.jpg")

result = run("kling-video-o3", {
    "image_url": image_url,
    "prompt": "smooth fur motion, eyes blinking",
    "duration": 5
})
print(result["output"]["url"])
```

### Музыка / TTS / текст

Аудио и текстовые модели работают через тот же `run`. Slug'и и параметры — через `models()` или [createya.ai/v1/models](https://api.createya.ai/v1/models). Полный каталог опубликованных моделей — на [createya.ai/knowledge](https://createya.ai/knowledge).

```python
# Получить все доступные text-модели
text_models = models(category="text")
for m in text_models:
    print(m["id"], m["family"])

# Получить audio-модели
audio_models = models(category="audio")
```

## Проверка баланса перед дорогой задачей

```python
b = balance()
if b["credits"] < 100:
    raise RuntimeError(f"Мало кредитов: {b['credits']}. Пополни: https://createya.ai")

result = run("kling-video-o3", {...})
```

## Параллельные async-задачи

```python
import concurrent.futures

prompts = [
    "Sunset over mountains",
    "Ocean waves crashing",
    "City skyline at night"
]

def gen(prompt):
    return run("nano-banana-2", {"prompt": prompt, "aspect_ratio": "16:9"})

with concurrent.futures.ThreadPoolExecutor(max_workers=3) as exe:
    results = list(exe.map(gen, prompts))

for r in results:
    print(r["output"]["urls"][0])
```

## Best practices

1. **Храни ключ в env vars**, не в коде. Через `python-dotenv` или systemd Environment=.
2. **Retry на 429/500** — экспоненциальный backoff (1, 2, 4, 8 сек).
3. **Один ключ — один сервис.** Если у тебя бот + бэкенд + cron-jobs, дай каждому отдельный ключ. Удобнее ротировать.
4. **Лог `run_id`** в свой application log — поможешь support'у быстро дебажить.
5. **Используй `parameters_schema`** через `models()` для построения форм / валидации.
