N8N Standalone
===

Ready-made configuration for launching [N8N](https://n8n.io/).

## 🚀 Quick Start

First of all, you need to clone the current repository.

```shell
$ git clone https://github.com/crasivo/n8n-standalone
$ cd n8n-standalone
```

Next, you need to choose a way to init <u>N8N</u>.
Below are examples of executing `make` commands for the first initialization of the application.

```shell
# local (via npm)
$ make local-init
# or docker
$ make docker-init
```

After the initial initialization (configuration) and the launch of all database migrations, the application will be available at http://localhost:5678

> [!TIP]
> For advanced users, the procedure for launching in manual mode (step by step) is described below.

## 🕹️ Usage

### Docker

The project contains two ready-made configurations for launching N8N:

- `minimal` — minimal configuration with SQLite3;
- `extended` — extended configuration with PostgreSQL and Redis.

> [!NOTE]
> The `minimal` configuration is used by default.
> For customization, just copy

Examples of commands to launch the `minimal` configuration application:

```shell
# copy & customize configurations
$ cp docker-compose.minimal.yml docker-compose.yml
$ touch .env
# up containers
$ docker compose up -d
```

Example commands to launch the `extended` configuration application:

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

The [Makefile](Makefile) file contains ready-made `make` commands for quickly creating backups (dump/snapshot) by archiving key directories.
This method is as fast as possible and does not require additional (external) utilities.

List of available commands:

- `local-dump-n8n` — archiving the entire `.n8n` folder;
- `docker-dump-n8n` — similar operation in a running docker container;
- `docker-dump-postgres` — archiving the `/var/lib/postgresql/data` folder in a running PostgreSQL container.

Example of running a command:

```shell
$ make <command>
```

---

## 📜 License

This project is distributed under the [MIT](https://en.wikipedia.org/wiki/MIT_License) license.
The full text of the license can be read in the [LICENSE.md](LICENSE.md) file.
