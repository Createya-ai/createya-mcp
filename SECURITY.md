# Security Policy / Политика безопасности

> 🇷🇺 [Русский](#-политика-безопасности-русский)
> 🇬🇧 [English](#-security-policy-english)

---

## 🇷🇺 Политика безопасности (русский)

### Что покрывает эта политика

- ✅ **Серверная инфраструктура Createya** — `api.createya.ai`, `createya.ai`, `sb.createya.ai`, OAuth flow, MCP-протокол, REST API, ключи `crya_sk_live_*`
- ✅ **Этот репозиторий** — `install.sh`, конфиги в `configs/`, skill в `skills/createya/`, плагин-манифест
- ❌ **NE покрывает** — клиентские агенты (Claude.ai, Cursor, Cline и т.д.), модели провайдеров (FLUX, Kling, и т.д.), сторонние интеграции

### Как сообщить об уязвимости

**Не открывай публичный issue** для уязвимостей. Используй приватные каналы:

📧 **Email:** [security@createya.ai](mailto:security@createya.ai)

Включи в письмо:

1. **Описание уязвимости** — что и где (URL / эндпоинт / файл репо)
2. **Шаги воспроизведения** — насколько подробно сможешь
3. **Потенциальный impact** — что может сделать злоумышленник
4. **Твои контакты** — email или Telegram, как с тобой связаться

### Что мы гарантируем

| | SLA |
|---|---|
| **Первичный ответ** | в течение 24 часов в рабочие дни (МСК) |
| **Подтверждение/отклонение** | до 5 рабочих дней |
| **Patch для critical** (RCE, auth bypass, утечка ключей) | до 7 дней с подтверждения |
| **Patch для high** (data exposure, privilege escalation) | до 30 дней |
| **Patch для medium/low** | в плановом релизе |

### Bug Bounty

Мы пока без публичной bug bounty программы, но:

- Указываем имя/ник ресёрчера в [CHANGELOG.md](CHANGELOG.md) (если он не против)
- Отдельно благодарим в Hall of Fame на сайте (готовится)
- Для серьёзных находок — индивидуальное вознаграждение по договорённости

### Что НЕ считается уязвимостью

- Слабые пароли в твоём аккаунте createya.ai (твоя ответственность)
- Возможность использовать наш API через VPN (это feature, не bug)
- Rate-limit срабатывает на твоих автотестах (увеличь интервал между запросами или подними план)
- Утечка ключа из-за плохого управления секретами на твоей стороне

### Координированное раскрытие

После того как мы исправили уязвимость:
- Не публикуй детали 7 дней с момента деплоя patch'а — даём пользователям время обновить интеграции
- После 7 дней — публикуй blog post / write-up как хочешь, мы дадим credit

---

## 🇬🇧 Security Policy (English)

### Scope

- ✅ **Createya server infrastructure** — `api.createya.ai`, `createya.ai`, `sb.createya.ai`, OAuth flow, MCP protocol, REST API, `crya_sk_live_*` keys
- ✅ **This repository** — `install.sh`, configs in `configs/`, skill in `skills/createya/`, plugin manifest
- ❌ **Out of scope** — client agents (Claude.ai, Cursor, Cline, etc.), provider models (FLUX, Kling, etc.), third-party integrations

### How to report

**Do not open a public issue** for vulnerabilities. Use private channels:

📧 **Email:** [security@createya.ai](mailto:security@createya.ai)

Please include:

1. **Description** — what and where (URL / endpoint / repo file)
2. **Reproduction steps** — as detailed as you can
3. **Potential impact** — what an attacker could do
4. **Your contacts** — email or Telegram for follow-up

### Our SLA

| | SLA |
|---|---|
| **First response** | within 24h on Russian business days |
| **Acknowledgment/dismissal** | up to 5 business days |
| **Critical patch** (RCE, auth bypass, key leak) | within 7 days of acknowledgment |
| **High patch** (data exposure, privilege escalation) | within 30 days |
| **Medium/low patch** | in scheduled release |

### Bug Bounty

We don't run a public bug bounty yet, but:

- Researcher credit in [CHANGELOG.md](CHANGELOG.md) (with your consent)
- Hall of Fame mention on our website (coming soon)
- Negotiated reward for serious findings

### Not considered vulnerabilities

- Weak passwords on your createya.ai account (your responsibility)
- Using our API via VPN (it's a feature, not a bug)
- Rate-limit triggered by your automated tests (increase interval or upgrade plan)
- Key leak due to poor secret management on your side

### Coordinated disclosure

After we ship a fix:
- Hold details for 7 days post-deploy — gives users time to update integrations
- After 7 days — publish a blog post / write-up as you wish, we'll provide credit

---

_Last updated: 2026-04-29_
