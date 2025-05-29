N8N Standalone
===

Готовая конфигурация для запуска [N8N](https://n8n.io/).

## 🚀 Быстрый старт

В первую очередь необходимо склонировать текущий репозиторий.

```shell
$ git clone https://github.com/crasivo/n8n-standalone
$ cd n8n-standalone
```

Далее необходимо выбрать способ развертывания <u>N8N</u>.
Ниже представлены примеры выполнения `make` команд для первой инициализации приложения.

```shell
# local (via npm)
$ make local-init
# or docker
$ make docker-init
```

После первичной инициализации (конфигурации) и запуска всех миграций БД приложение будет доступно по адресу http://localhost:5678

> [!TIP]
> Для продвинутых пользователей ниже описана процедура запуска в ручном режиме (step by step).

## 🕹️ Эксплуатация

### Docker

В проекте присутствуют две готовые конфигурации для запуска N8N:

- `minimal` — минимальная конфигурация с SQLite3;
- `extended` — расширенная конфигурация с PostgreSQL и Redis.

> [!NOTE]
> По умолчанию используется конфигурация `minimal`.
> Для кастомизации достаточно скопировать

Примеры команд для запуска приложения `minimal` конфигурации:

```shell
# copy & customize configurations
$ cp docker-compose.minimal.yml docker-compose.yml
$ touch .env
# up containers
$ docker compose up -d
```

Пример команд для запуска приложения `extended` конфигурации:

```shell
# copy & customize configurations
$ cp docker-compose.extended.yml docker-compose.yml
$ touch .env
# generate secrets
$ mkdir ./secrets
$ tr -dc A-Za-z0-9 < /dev/urandom | head -c 20 > ./secrets/n8n_postgres.pass
$ tr -dc a-f0-9 < /dev/urandom | head -c 64 > ./secrets/n8n_encryption.key
# up containers
$ docker compose up -d
```

### Backup

В файле [Makefile](Makefile) присутствуют готовые `make` команды для быстрого создания резервных копий (dump/snapshot) путем архивации ключевых директорий.
Данный способ максимально быстрый и не требует дополнительных (внешних) утилит.

Список доступных команд:

- `local-dump-n8n` — архивация всей папки `.n8n`;
- `docker-dump-n8n` — аналогичная операция в запущенном docker контейнере;
- `docker-dump-postgres` — архивация папки `/var/lib/postgresql/data` в запущенном контейнере PostgreSQL.

Пример запуска команды:

```shell
$ make <command>
```

---

## 📜 Лицензия

Данный проект распространяется по лицензии [MIT](https://en.wikipedia.org/wiki/MIT_License).
Полный текст лицензии можно прочитать в файле [LICENSE.md](LICENSE.md).
