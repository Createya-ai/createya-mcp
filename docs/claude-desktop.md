# Claude Desktop — Установка и использование Createya

Claude Desktop — приложение с графическим интерфейсом для macOS и Windows. Вкладка **Code** идентична CLI, плюс добавляется drag-drop медиафайлов и GUI для Connectors (MCP).

## Совместимость

| Функция | Статус |
|---------|--------|
| Skill (SKILL.md) | ✅ Полная поддержка (тот же engine что CLI) |
| MCP (Connectors) | ✅ Через GUI + одинаковый config с CLI |
| Drag-drop файлов | ✅ Да (перетащи в prompt поле) |
| Vision | ✅ Нативно — перетащи изображение |
| OAuth flow | ✅ Графический wizard |

## Требования

- Claude Desktop: скачать на [claude.ai](https://claude.ai)
  - Требует платную подписку: Pro, Max, Team или Enterprise
- Аккаунт Createya с API ключом: [createya.ai/settings/api-keys](https://createya.ai/settings/api-keys)

## Скачать

| Платформа | Ссылка |
|-----------|--------|
| macOS (Universal) | [Скачать .dmg](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect) |
| Windows x64 | [Скачать setup.exe](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect) |
| Windows ARM64 | [Скачать setup.exe](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect) |
| Linux | CLI только (Desktop недоступен) |

## Установка

### Шаг 1: Установить plugin

В Desktop app перейди на вкладку **Code**, затем:

1. Кнопка **+** рядом с prompt box → **Plugins**
2. Нажать **Add plugin**
3. В поиске: `createya` или вставить URL: `github:Createya-ai/createya-mcp`
4. Нажать **Install** → plugin появится в списке Installed

Или через CLI (если установлен):
```bash
claude plugin marketplace add Createya-ai/createya-mcp
claude plugin install creative-director@createya-mcp
```

### Шаг 2: Подключить MCP Connector

В Desktop app:

1. **+** рядом с prompt box → **Connectors**
2. Нажать **Add connector**
3. Ввести URL сервера: `https://api.createya.ai/mcp`
4. Если появляется OAuth экран — авторизоваться через Createya

Или настроить вручную через CLI:
```bash
claude mcp add createya \
  --transport http \
  https://api.createya.ai/mcp \
  --header "Authorization: Bearer crya_sk_live_ваш_ключ"
```

### Шаг 3: Создать рабочее пространство

Открой Terminal на вкладке Code и запусти:
```bash
cd ~/Documents/my-photo-project
bash ~/.claude/plugins/creative-director/scripts/setup.sh
```

## Drag-drop референсов

Это главное преимущество Desktop перед CLI:

1. Открой проект с папкой `creative/assets/`
2. Перетащи фото прямо в prompt поле
3. Напиши задачу — агент автоматически вызовет `Read` на изображение

Пример:
```
[перетащить sarah.jpg]
Это будет наша референсная модель. Воссоздай её с помощью nano-banana-pro,
сделай три ракурса: фронтальный, 3/4, профиль. Белый фон, студийный свет.
```

Агент сам загрузит фото через `request_upload_url` и использует CDN URL как `referenceImages`.

## Управление Connectors

**Settings → Connectors** — список всех подключённых MCP серверов:
- Enable/disable без удаления
- Просмотр доступных инструментов
- Переавторизация (при истечении токена)

Изменения в GUI синхронизируются с `~/.claude/settings.json` — конфиг общий с CLI.

## Параллельные сессии

Desktop поддерживает вкладку **Cowork** для долгих background задач (cloud VM). Для creative-director рекомендуется обычная вкладка **Code** — визуальный контроль важнее для медиа-генераций.

## Troubleshooting

**Plugin не появляется в списке:**
1. Перейди в Settings → Plugins → Reload
2. Или в промпте: `/reload-plugins`

**Connector не подключается:**
1. Проверь что API ключ правильный: Settings → Connectors → Edit
2. Проверь сеть: `curl https://api.createya.ai/mcp`

**Vision не работает на перетащенном файле:**
Убедись что файл — JPEG/PNG/WebP (не PDF). Размер до 20 МБ.

## Поддержка

- Issues: [github.com/Createya-ai/createya-mcp/issues](https://github.com/Createya-ai/createya-mcp/issues)
- Email: support@createya.ai
- Claude Desktop docs: [claude.ai/code](https://claude.ai/code)
