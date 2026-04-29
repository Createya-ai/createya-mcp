# Contributing to Createya MCP

Спасибо что хочешь помочь! Этот репозиторий — публичная витрина для подключения [Createya](https://createya.ai) через MCP / REST.

> 🇬🇧 English version below.

---

## 🇷🇺 Что мы принимаем (PR welcome)

- ✅ **Новые конфиги MCP-клиентов** в `configs/` — если появился новый агент-фреймворк (Aider, CodeBuff, Continue.dev и т.д.)
- ✅ **Новые примеры** в `examples/` — на твоём любимом языке (PHP, Ruby, Rust, Java, .NET и т.д.)
- ✅ **Улучшения README** — опечатки, неточности, более ясные формулировки
- ✅ **Перевод документации** — мы поддерживаем русский (основной) и английский. Если хочешь добавить китайский / испанский / немецкий — welcome
- ✅ **Bug-фиксы** в `install.sh` или skill (`skills/createya/SKILL.md`)
- ✅ **Запросы на новые модели** — открой [issue](https://github.com/Createya-ai/createya-mcp/issues/new) с описанием use-case

## Что мы НЕ принимаем

- ❌ Изменения в `https://api.createya.ai/*` — это серверная сторона, живёт в приватном репо
- ❌ Свои "форки" Createya MCP — нарушение лицензии
- ❌ Promotional spam в README / examples
- ❌ Конфиги/примеры с реальными API-ключами (используй `REPLACE_WITH_YOUR_KEY` placeholder)

## Workflow

### 1. Перед изменениями

- **Открой issue** для крупных изменений (новый пример, новый клиент-конфиг). Согласуем формат
- **Мелкие правки** (typos, фиксы ссылок) — сразу PR без issue

### 2. Делай форк → ветку → PR

```bash
git clone https://github.com/your-username/createya-mcp.git
cd createya-mcp
git checkout -b feat/aider-config       # или fix/typo-readme
# ... твои изменения
git commit -m "feat(configs): add Aider MCP config"
git push origin feat/aider-config
```

→ открой PR в `main` репо `Createya-ai/createya-mcp`.

### 3. Стиль commit-сообщений

Используем [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(configs): add Aider MCP config
feat(examples): add Rust example with reqwest
fix(install): handle missing git binary gracefully
docs(readme): clarify Cline streamableHttp vs http
chore(skills): bump SKILL.md version to 1.1.0
```

Type'ы: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`.
Scope'ы: `configs`, `examples`, `install`, `skills`, `readme`, `workflows`.

### 4. Стиль контента

#### Новый конфиг (`configs/<client>.json`)

- Префикс `_comment` с **точным путём** где этот конфиг должен лежать в системе пользователя
- Placeholder `crya_sk_live_REPLACE_WITH_YOUR_KEY` — никогда реальные ключи
- Минимальный конфиг (без лишних полей которые наш сервер не использует)

Пример:
```json
{
  "_comment": "Aider config. Path: ~/.aider/config.json. Restart Aider after adding.",
  "mcpServers": {
    "createya": {
      "type": "http",
      "url": "https://api.createya.ai/mcp",
      "headers": {
        "Authorization": "Bearer crya_sk_live_REPLACE_WITH_YOUR_KEY"
      }
    }
  }
}
```

#### Новый пример (`examples/<NN>-rest-<lang>.md`)

- Номер `<NN>` — следующий после последнего (сейчас 10)
- Структура: вступление → код → пояснение → next steps (ссылки)
- Используй реальные модели из live-каталога: `nano-banana-2`, `gpt-image-2-edit`, `kling-video-o3`
- env var `CREATEYA_API_KEY` — никогда хардкоженый ключ

#### Skill (`skills/createya/SKILL.md`)

Изменения в skill требуют отдельного review — это содержание которое читают AI-агенты, неточности приведут к плохой UX. Если хочешь править — открой issue первым с описанием почему.

### 5. Проверка перед PR

Минимум:
- [ ] JSON-конфиги валидны (`python3 -m json.tool < configs/your.json`)
- [ ] Markdown-ссылки работают (visual check)
- [ ] Не закоммитил реальный ключ (`git diff | grep crya_sk_live` должен быть пустой)

### 6. Что после PR

- CI проверит `JSON validate` и `markdown links`
- Maintainer (Артур) посмотрит PR в течение 2-3 рабочих дней
- Если есть вопросы / нужны правки — комментарий в PR
- Merge через squash → попадает в `main` → автоматически попадает в [GitHub release](https://github.com/Createya-ai/createya-mcp/releases) при следующем теге

## Code of Conduct

Будь вежлив. Конструктивная критика — ОК, переход на личности — нет. См. [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).

## Лицензия

Контрибьютя, ты соглашаешься что твой код будет под [MIT License](LICENSE).

## Связь

- 🐙 GitHub Issues: [issues](https://github.com/Createya-ai/createya-mcp/issues)
- 📧 Email: [support@createya.ai](mailto:support@createya.ai) — для непубличных вопросов
- 💬 Telegram-бот: [@createya_bot](https://t.me/createya_bot)

---

## 🇬🇧 What we accept (English)

- ✅ **New MCP client configs** in `configs/` — Aider, CodeBuff, Continue.dev, etc.
- ✅ **New examples** in `examples/` — in your preferred language (PHP, Ruby, Rust, Java, .NET, etc.)
- ✅ **README improvements** — typos, clarifications
- ✅ **Documentation translations** — Russian (primary) and English currently. Chinese / Spanish / German welcome
- ✅ **Bug fixes** in `install.sh` or skill
- ✅ **Model requests** — open an [issue](https://github.com/Createya-ai/createya-mcp/issues/new) describing the use-case

### What we don't accept

- ❌ Changes to `https://api.createya.ai/*` — that's server-side, lives in a private repo
- ❌ Forks marketed as "Createya MCP" — license violation
- ❌ Promotional spam
- ❌ Real API keys in configs/examples (use `REPLACE_WITH_YOUR_KEY` placeholder)

### Workflow

Standard fork → branch → PR. Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `chore:`).

For large changes (new examples, new client configs) — open an issue first.

JSON configs must validate. Examples must use `CREATEYA_API_KEY` env var, never hardcoded keys.

Maintainer review within 2-3 business days. Merge via squash.

### Code of Conduct

Be kind. See [Contributor Covenant](https://www.contributor-covenant.org/).

### License

By contributing you agree your code is under [MIT License](LICENSE).
