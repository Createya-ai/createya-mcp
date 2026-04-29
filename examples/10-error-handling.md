# Пример 10 — Обработка ошибок

Все ошибки от api.createya.ai приходят в едином формате (OpenAI-совместимый):

```json
{
  "error": {
    "message": "Concurrent generation limit reached (2/2). Wait for a running generation to finish, or upgrade your plan at https://createya.ai/settings/billing",
    "type": "rate_limit_error",
    "code": "concurrent_limit_exceeded",
    "param": null
  }
}
```

| Поле | Что |
|---|---|
| `error.code` | Машиночитаемый код — на нём строй retry-логику |
| `error.message` | Human-readable сообщение, можно показать пользователю |
| `error.type` | Класс ошибки: `invalid_request_error`, `rate_limit_error`, `authentication_error`, `api_error` |
| `error.param` | Имя параметра если ошибка валидации (иначе `null`) |

## Полный список кодов

### 401 Unauthorized — `authentication_error`

| Код | Что делать |
|---|---|
| `invalid_api_key` | Ключ не существует или неверный формат. Проверь префикс `crya_sk_live_` и длину 32 hex после префикса |
| `revoked_api_key` | Ключ отозван юзером. Создай новый на [/settings/api-keys](https://createya.ai/settings/api-keys) |
| `expired_api_key` | TTL истёк. Создай новый или продли |

### 403 Forbidden — `permission_denied`

| Код | Что делать |
|---|---|
| `ip_not_allowed` | У ключа задан `allowed_ips` whitelist, твой IP не в нём. Добавь IP или убери whitelist |
| `model_not_allowed` | У ключа задан `allowed_models` whitelist, эта модель не в нём. Используй другую модель или сними ограничение |
| `insufficient_scope` | У ключа нет нужного scope (`generate` / `read:usage`). Создай новый ключ с нужными scopes |

### 402 Payment Required

| Код | Что делать |
|---|---|
| `insufficient_credits` | На workspace недостаточно кредитов. Пополни на [createya.ai/settings/billing](https://createya.ai/settings/billing) |

### 404 Not Found

| Код | Что делать |
|---|---|
| `model_not_found` | Slug не найден. Проверь актуальный список через `GET /v1/models` |
| `run_not_found` | `run_id` не существует или принадлежит другому workspace |

### 422 Unprocessable Entity — `invalid_request_error`

| Код | Что делать |
|---|---|
| `model_required` | Не передал поле `model` |
| `input_invalid` | `input` не объект или невалидный |
| `invalid_json` | Body не валидный JSON |
| `invalid_input` | Параметры не подходят модели. Проверь `parameters_schema` через `/v1/models` |

### 429 Too Many Requests — `rate_limit_error` ⭐ важно

| Код | Что делать |
|---|---|
| `concurrent_limit_exceeded` | Достигнут лимит одновременных генераций (от тарифа: Starter=1, Creator=2, Pro=3, Enterprise=4). Дождись завершения активных или апгрейдь тариф |
| `anon_rate_limit_exceeded` | Anon-эндпоинты (без ключа) — превышен IP rate-limit 120 r/min. Используй с ключом или ретрай через `Retry-After` секунд |

В ответе на 429 приходит заголовок `Retry-After: <secs>` — сколько ждать перед повтором.

### 500-502 — `api_error`

| Код | Что делать |
|---|---|
| `upstream_error` | Провайдер вернул ошибку. Попробуй повторить или другую модель |
| `upstream_timeout` | Провайдер не ответил вовремя. Повтори через 30-60 сек |
| `provider_unavailable` | Провайдер недоступен (5xx). Повтори с exponential backoff |
| `internal_error` | Наша ошибка. Сообщи в [support@createya.ai](mailto:support@createya.ai) если повторяется |

## Pattern: Exponential backoff с jitter (правильный)

Стандарт для API-клиентов: при 429/503 ждать `Retry-After` если есть, иначе `2^attempt * (1 ± 20%)` секунд.

### Python

```python
import time, random, requests

def call_with_retry(url, method="POST", max_attempts=5, **kwargs):
    for attempt in range(max_attempts):
        r = requests.request(method, url, **kwargs)

        # Успех — или клиентская ошибка которую не надо ретраить
        if r.status_code < 500 and r.status_code != 429:
            return r

        # Ретраим
        retry_after = int(r.headers.get("Retry-After", 2 ** attempt))
        # ±20% jitter чтоб клиенты не синхронизировались
        sleep = retry_after * (1 + random.uniform(-0.2, 0.2))
        print(f"  attempt {attempt+1}/{max_attempts}: HTTP {r.status_code}, retry in {sleep:.1f}s")
        time.sleep(sleep)

    # После всех попыток — последний raise_for_status
    r.raise_for_status()
    return r
```

### TypeScript

```typescript
async function callWithRetry(
  url: string,
  init: RequestInit = {},
  maxAttempts = 5
): Promise<Response> {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const r = await fetch(url, init);

    // Успех или non-retryable (4xx кроме 429)
    if (r.status < 500 && r.status !== 429) return r;

    const retryAfter = Number(r.headers.get("retry-after") ?? Math.pow(2, attempt));
    const jitter = 1 + (Math.random() * 0.4 - 0.2); // ±20%
    const sleepMs = retryAfter * 1000 * jitter;
    console.warn(`Attempt ${attempt + 1}/${maxAttempts}: HTTP ${r.status}, retry in ${sleepMs.toFixed(0)}ms`);
    await new Promise(res => setTimeout(res, sleepMs));
  }
  throw new Error("Max retry attempts exceeded");
}
```

### Что НЕ ретраить

Никогда не ретрай на:
- **401/403** — ключ невалидный, ретраи не помогут
- **402** — нет денег, ретраи не помогут
- **404** — модель не существует
- **422** — твои параметры неверные

Ретрай только **429, 502, 503, 504** и сетевые ошибки.

## Чтение rate-limit headers (proactive throttling)

Лучше **не упираться** в 429 а тормозить заранее. Используй headers:

```
RateLimit-Limit: 120
RateLimit-Remaining: 47
RateLimit-Reset: 32
X-Concurrent-Limit: 5
X-Concurrent-Active: 3
```

Pattern: если `RateLimit-Remaining` < 10 — притормози. Если `X-Concurrent-Active >= X-Concurrent-Limit - 1` — поставь в очередь.

```python
r = requests.post(...)

remaining = int(r.headers.get("RateLimit-Remaining", 999))
if remaining < 10:
    # Скоро 429 — пауза
    time.sleep(int(r.headers.get("RateLimit-Reset", 5)))

active = int(r.headers.get("X-Concurrent-Active", 0))
limit = int(r.headers.get("X-Concurrent-Limit", 99))
if active >= limit - 1:
    # На грани — ставь новые задачи в очередь
    queue.put(next_request)
```

## User-friendly сообщения

Когда показываешь ошибку пользователю — мапь `error.code` в человеческое сообщение:

```typescript
const friendlyMessage: Record<string, string> = {
  invalid_api_key: "Проверьте API-ключ — он невалидный или истёк",
  insufficient_credits: "Недостаточно кредитов. Пополнить: https://createya.ai/settings/billing",
  concurrent_limit_exceeded: "Слишком много одновременных запросов. Подождите завершения активных",
  model_not_allowed: "Эта модель недоступна для вашего ключа",
  invalid_input: "Параметры не подходят модели. Проверьте список через /v1/models",
  upstream_error: "Временная проблема у провайдера. Повторите через минуту",
};

function showError(error: { code: string; message: string }) {
  const userMsg = friendlyMessage[error.code] ?? error.message;
  alert(userMsg); // или toast / notification
}
```

## Логирование для дебага

Полезно логировать:
- `error.code` (для группировки в Sentry/Loki)
- `request_id` из `X-Request-Id` header — пригодится если будешь обращаться в support
- Тело запроса (без ключа!) если ошибка валидации

## Связанные примеры

- [`03-async-polling.md`](03-async-polling.md) — обработка ошибок при polling
- [`05-rest-curl.md`](05-rest-curl.md) — базовые REST вызовы
- Полная документация по rate-limits: [createya.ai/api/rate-limits](https://createya.ai/api/rate-limits)
