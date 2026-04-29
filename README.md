<div align="center">

<img src="assets/logo.png" alt="Createya" width="320"/>

# Createya MCP & API

### Мир нейросетей без границ.
#### Через MCP или REST. Без VPN. Оплата в рублях.

[![MCP](https://img.shields.io/badge/MCP-2025--06--18-7C3AED?style=flat-square)](https://modelcontextprotocol.io/)
[![REST](https://img.shields.io/badge/REST-OpenAPI%203.1-3B82F6?style=flat-square)](https://api.createya.ai/v1/openapi.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)
[![No VPN](https://img.shields.io/badge/No%20VPN-required-EF4444?style=flat-square)]()
[![Models](https://img.shields.io/badge/Models-148%20endpoints-F59E0B?style=flat-square)](docs/models-image.md)

[🚀 Быстрый старт](#-за-60-секунд) · [🤖 MCP](#-что-делает-mcp-сервер) · [📡 REST](#-без-mcp--обычный-rest-api) · [🎨 Модели](#-каталог-моделей) · [⚙️ Подключение](#%EF%B8%8F-подключение-выберите-свой-инструмент) · [🏢 Юрлицам](#-для-юридических-лиц) · [💬 Поддержка](#-связь)

---

**Подключи нейросети Createya к своему AI-агенту через MCP или к своему коду через REST. Без VPN. Оплата в рублях. 100 кредитов бесплатно на старте.**

**Два пути на выбор:**
- 🤖 **MCP** — для AI-агентов (Claude, Cursor, Cline, Windsurf, Codex, OpenCode). Один URL, OAuth или Bearer — и агент сам видит каталог моделей.
- 📡 **REST** — для своего кода. Один Bearer-токен, `POST /v1/run`, готовые примеры на curl / Python / Node.js / Go.

</div>

---

## 🎯 Зачем это нужно

Эпоха AI-агентов наступила. Claude, Cursor, Cline, OpenCode, Codex — каждую неделю появляется новый агент-фреймворк. Все они работают через **MCP** (Model Context Protocol) — открытый стандарт от Anthropic для подключения внешних инструментов.

Createya решает 4 типичные проблемы:

| Проблема | Решение Createya |
|---|---|
| Геоблокировки и нужен VPN | Прямой доступ — VPN не требуется |
| Зарубежные карты не принимают | Карты РФ, СБП, Т-Пэй — оплата в рублях |
| Десятки сервисов с разными ключами | Каталог моделей через **один API-ключ** |
| Локальное хранение данных (152-ФЗ) | Все данные хранятся локально, полное соответствие закону |
| Юрлица и B2B | Договор, счёт, акт. Оплата по безналичному расчёту с НДС |

И всё это — через **MCP** (для агентов) или обычный **REST** (для своего кода).

---

## ⚡ За 60 секунд

**1. Зарегистрируйся → получи 100 бесплатных кредитов**
[createya.ai](https://createya.ai)

**2. Создай API-ключ** (формат `crya_sk_live_<32hex>`)
[createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)

**3. Дальше — выбираешь свой путь:**

### 🤖 Если ты строишь AI-агента → MCP
```
Подключи https://api.createya.ai/mcp к Claude / Cursor / Cline / Windsurf
В чате: «Сгенерируй картинку через Createya — кот на луне»
```
[→ Инструкции для всех клиентов](#%EF%B8%8F-подключение-выберите-свой-инструмент)

### 💻 Если ты пишешь свой код → REST
```bash
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{"model":"nano-banana-2","input":{"prompt":"кот на луне"}}'
```
[→ Полные примеры на curl / Python / Node.js / Go](#-без-mcp--обычный-rest-api)

> 💡 **100 кредитов бесплатно** на старте. Тарифы и пополнение — на сайте: [createya.ai](https://createya.ai).

---

## 🤖 Что делает MCP-сервер

После подключения у вашего агента появляются **4 инструмента**:

| Tool | Описание |
|---|---|
| 🔍 **`list_models`** | Каталог всех моделей с `parameters_schema`. Агент сам узнаёт что можно вызывать. |
| 🎨 **`run_model`** | Запуск генерации: `{ model: <slug или family>, input: {...} }`. Картинка / видео / аудио / текст. |
| ⏳ **`get_run_status`** | Опросить статус async-задачи (видео обычно генерится 30-180 сек). |
| 💰 **`get_balance`** | Текущий баланс кредитов workspace. |

**Endpoint:** `https://api.createya.ai/mcp`
**Транспорт:** Streamable HTTP (MCP spec 2025-06-18)
**Авторизация:** OAuth 2.1 (для Claude.ai) или Bearer-заголовок (для всего остального)

---

## ⚙️ Подключение — выберите свой инструмент

### A. OAuth — самый простой путь (Claude Desktop / Claude.ai / Claude Code)

1. **Claude.ai** → [Settings → Connectors](https://claude.ai/settings/connectors) → **Add custom connector**
   **Claude Desktop** → меню `+` → `Connectors` → `Add custom connector`
2. URL сервера: `https://api.createya.ai/mcp`
3. Claude откроет страницу авторизации Createya — вставь свой `crya_sk_live_...` ключ → **Разрешить**
4. Готово. Tools (`list_models`, `run_model`...) появятся в чате.

> 💡 Каждому участнику команды — свой ключ. Кредиты списываются с workspace, к которому привязан ключ.

### B. Claude Code (CLI)

```bash
claude mcp add createya "https://api.createya.ai/mcp" \
  --transport http \
  --header "Authorization: Bearer crya_sk_live_..."
```

> ⚠ Заголовок передаётся через `:` (двоеточие + пробел), **не через** `=`. Это самая частая ошибка.

### C. Cursor

`~/.cursor/mcp.json` (глобально) или `.cursor/mcp.json` (в проекте):
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

В `settings.json`:
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
> Тип — `streamableHttp` (camelCase, без дефиса).

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

См. [`configs/codex.toml`](configs/codex.toml) и [`configs/opencode.json`](configs/opencode.json) — готовые шаблоны.

### G. Любой другой MCP-клиент

Готовые конфиги — в папке [`configs/`](configs/). Скопируй нужный, замени `crya_sk_live_...` на свой ключ — готово.

---

## 🎨 Каталог моделей

Полная актуальная документация с примерами на curl/Python/Node.js — на отдельном поддомене **[docs.createya.ai/models/](https://docs.createya.ai/models/)** (синхронизируется с live API раз в неделю).

### Сейчас публично доступны через MCP/REST (5 endpoints)

| Модель | Тип | Slug | Подробнее |
|---|---|---|---|
| **Nano Banana 2** | image | `nano-banana-2` | [docs.createya.ai/models/nano-banana-2](https://docs.createya.ai/models/nano-banana-2) |
| **Nano Banana 2 Edit** | image (i2i) | `nano-banana-2-edit` | [docs.createya.ai/models/nano-banana-2-edit](https://docs.createya.ai/models/nano-banana-2-edit) |
| **Nano Banana Pro** | image | `nano-banana-pro` | [docs.createya.ai/models/nano-banana-pro](https://docs.createya.ai/models/nano-banana-pro) |
| **GPT Image 2** | image | `gpt-image-2` | [docs.createya.ai/models/gpt-image-2](https://docs.createya.ai/models/gpt-image-2) |
| **GPT Image 2 Edit** | image (i2i) | `gpt-image-2-edit` | [docs.createya.ai/models/gpt-image-2-edit](https://docs.createya.ai/models/gpt-image-2-edit) |

### Coming soon (140+ endpoints)

В работе — открытие публичного доступа к остальным семействам:
**FLUX 2 / Kontext** · **Sora 2** · **Veo 3.1** / Fast · **Kling Video O3 / V3 / 4K** · **Seedance 2.0** · **Happy Horse** · **Hailuo 2.3** · **Higgsfield Soul** · **Midjourney** · **Runway Gen-4** · **Recraft** · **Ideogram** · **Imagen** · **Wan** · **Grok Imagine** · **Seedream** и др.

📚 **Live-каталог** через API: `GET https://api.createya.ai/v1/models` (публичный, без auth)
📖 **Маркетинговый обзор** моделей: [createya.ai/knowledge](https://createya.ai/knowledge)
📡 **Документация API** + per-model страницы: [docs.createya.ai](https://docs.createya.ai)

---

## 💡 Примеры использования

### Сгенерировать картинку

```
Ты: Сгенерируй картинку через Createya — кот на луне в стиле Studio Ghibli, формат 16:9
Агент: [вызывает createya:run_model с model=nano-banana-2]
       → возвращает CDN-ссылку на изображение
```

[`examples/01-generate-image.md`](examples/01-generate-image.md) — больше деталей.

### Сгенерировать видео

```
Ты: Возьми эту картинку (URL) и оживи через Kling, 5 секунд
Агент: [вызывает createya:run_model с model=kling-video-o3, image_url=...]
       → возвращает run_id
       → через 30-60 сек: createya:get_run_status → готовое видео
```

[`examples/02-generate-video.md`](examples/02-generate-video.md)

### REST без MCP

- [`examples/05-rest-curl.md`](examples/05-rest-curl.md) — curl (sync + async + upload)
- [`examples/06-rest-python.md`](examples/06-rest-python.md) — Python client
- [`examples/07-rest-nodejs.md`](examples/07-rest-nodejs.md) — TypeScript / Node.js / Express / Next.js
- [`examples/08-rest-go.md`](examples/08-rest-go.md) — Go (stdlib, без зависимостей)
- [`examples/09-rest-php.md`](examples/09-rest-php.md) — PHP / Laravel / Symfony
- [`examples/03-async-polling.md`](examples/03-async-polling.md) — async-задачи (видео) с exponential backoff
- [`examples/04-upload-image.md`](examples/04-upload-image.md) — загрузка картинки для image-to-image
- [`examples/10-error-handling.md`](examples/10-error-handling.md) — обработка всех ошибок, retry-pattern

---

## 📡 Без MCP — обычный REST API

Если ты не агент, а просто разработчик — есть REST API. Один Bearer-токен, один POST, готово.

### Шаг 1 — получить токен

1. Зарегистрируйся на [createya.ai](https://createya.ai) (получишь 100 бесплатных кредитов)
2. Зайди в [createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)
3. **Create new key** → дай ему имя (например `my-bot-prod`) → **Create**
4. **Скопируй ключ** — он показывается **один раз**. Формат: `crya_sk_live_<32hex>`
5. Храни как пароль (env var, secret manager, не в git)

### Шаг 2 — первый запрос

```bash
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "nano-banana-2",
    "input": {
      "prompt": "кот на луне в стиле Studio Ghibli",
      "aspect_ratio": "16:9"
    }
  }'
```

**Ответ:**
```json
{
  "run_id": "run_01HZX...",
  "status": "completed",
  "output": {
    "urls": ["https://cdn-new.createya.ai/image/profile-id/abc123.png"]
  }
}
```

### Шаг 3 — Python / Node.js / Go

**Python** (с `requests`):
```python
import os, requests

KEY = os.environ["CREATEYA_API_KEY"]
r = requests.post(
    "https://api.createya.ai/v1/run",
    headers={"Authorization": f"Bearer {KEY}"},
    json={"model": "nano-banana-2", "input": {"prompt": "кот на луне"}}
)
print(r.json()["output"]["urls"][0])
```

**Node.js** (нативный fetch, Node 18+):
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
    input: { prompt: "кот на луне" }
  })
});
const json = await r.json();
console.log(json.output.urls[0]);
```

**Go**:
```go
body := strings.NewReader(`{"model":"nano-banana-2","input":{"prompt":"кот на луне"}}`)
req, _ := http.NewRequest("POST", "https://api.createya.ai/v1/run", body)
req.Header.Set("Authorization", "Bearer "+os.Getenv("CREATEYA_API_KEY"))
req.Header.Set("Content-Type", "application/json")
resp, _ := http.DefaultClient.Do(req)
```

→ Полные примеры: [`examples/05-rest-curl.md`](examples/05-rest-curl.md), [`examples/06-rest-python.md`](examples/06-rest-python.md), [`examples/07-rest-nodejs.md`](examples/07-rest-nodejs.md)

### Async-задачи (видео, длинная музыка)

```bash
# Шаг 1 — запуск
curl -X POST https://api.createya.ai/v1/run \
  -H "Authorization: Bearer crya_sk_live_..." \
  -H "Content-Type: application/json" \
  -d '{"model":"kling-video-o3","input":{"image_url":"https://...","duration":5}}'
# → 202 Accepted, { "run_id": "run_01J2...", "status": "queued" }

# Шаг 2 — polling каждые 10 сек
curl https://api.createya.ai/v1/runs/run_01J2... \
  -H "Authorization: Bearer crya_sk_live_..."
# → { "status": "completed", "output": { "url": "https://cdn-new.createya.ai/video/..." } }
```

### Все REST-эндпоинты

| Метод | URL | Что делает |
|---|---|---|
| `GET` | `/v1/models` | Каталог всех моделей с `parameters_schema` |
| `POST` | `/v1/run` | Запустить генерацию |
| `GET` | `/v1/runs/{run_id}` | Статус async-задачи |
| `GET` | `/v1/balance` | Баланс кредитов workspace |
| `POST` | `/v1/uploads` | Загрузить картинку/видео в Createya CDN (для image-to-image) |
| `GET` | `/v1/openapi.json` | OpenAPI 3.1 спека (для автогенерации SDK) |

### Машиночитаемые спеки

- **OpenAPI 3.1**: `https://api.createya.ai/v1/openapi.json` — для автогенерации Python/TypeScript/Java/Ruby SDK
- **llms.txt**: `https://api.createya.ai/llms.txt` — карта API для AI-агентов
- **Полная документация**: [createya.ai/api](https://createya.ai/api)

---

## 🏢 Для юридических лиц

Createya работает с компаниями по договору и безналу.

- **Безналичный расчёт** — выставляем счёт, оплата с расчётного счёта компании
- **Договор + акт** — закрывающие документы для бухгалтерии
- **НДС** — счета с НДС или без, по запросу
- **Объёмные пакеты** — оптовая скидка обсуждается индивидуально
- **API под нагрузку** — повышенные rate limits, выделенные ключи на сервисы
- **152-ФЗ** — все данные хранятся локально, полное соответствие закону «О персональных данных»
- **White-label** — Telegram-бот / web под вашим брендом возможен

📩 Реквизиты и счёт за 1 рабочий день: [support@createya.ai](mailto:support@createya.ai)

---

## 🔐 Безопасность

- **API-ключи** — формат `crya_sk_live_<32hex>`, хранятся хешированно (bcrypt)
- **Workspace isolation** — ключ привязан к одному workspace, не может списать кредиты с другого
- **OAuth 2.1 + PKCE** — для web-клиентов (Claude.ai)
- **Rate limits** — на уровне ключа, защита от утечек
- **152-ФЗ** — все данные хранятся локально

---

## 📚 Документация

| Документ | Где |
|---|---|
| Quickstart REST | [createya.ai/api/getting-started](https://createya.ai/api/getting-started) |
| Полная REST-спека | [createya.ai/api/rest](https://createya.ai/api/rest) |
| MCP-коннектор | [createya.ai/api/mcp](https://createya.ai/api/mcp) |
| OpenAPI 3.1 | [api.createya.ai/v1/openapi.json](https://api.createya.ai/v1/openapi.json) |
| Каталог моделей | [createya.ai/knowledge](https://createya.ai/knowledge) |
| Примеры в этом репо | [`examples/`](examples/) |

---

## 💬 Связь

- 🌐 **Сайт:** [createya.ai](https://createya.ai)
- 📚 **База знаний:** [createya.ai/knowledge](https://createya.ai/knowledge)
- 🤖 **Telegram-бот** (для генерации напрямую без кода): [@createya_bot](https://t.me/createya_bot)
- 📧 **Поддержка:** [support@createya.ai](mailto:support@createya.ai)
- 💼 **Партнёрство / Амбассадорам:** [createya.ai/ambassador](https://createya.ai/ambassador)

---

## 🤝 Контрибьютим

PRs welcome — новый MCP-клиент конфиг, новый язык в примерах, фикс опечатки. См. [CONTRIBUTING.md](CONTRIBUTING.md) для guideline'ов.

Нашёл баг или хочешь модель — открой [issue](https://github.com/Createya-ai/createya-mcp/issues/new/choose).

Уязвимость? Не открывай публичный issue — пиши на [security@createya.ai](mailto:security@createya.ai). См. [SECURITY.md](SECURITY.md).

---

## 📄 Лицензия

[MIT](LICENSE) — бери, форкай, делай свои интеграции. Только укажи нас как автора.

---

<div align="center">

**Createya — мир нейросетей без границ. Для AI-агентов всего мира.**

⭐ Поставь звезду если репо помог!

</div>
