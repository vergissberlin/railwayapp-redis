# Redis for railway.app

![Template Header](./template-header.svg)

Redis is an open-source, in-memory data store used as a database, cache, message broker, and queue, prized for its speed and simple key-value model with support for richer structures like lists, sets, and hashes. This template deploys Redis 8 on Railway using the official Docker image, with append-only persistence and password authentication enabled by default.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/redis-2?referralCode=2_sIT9&utm_medium=integration&utm_source=template&utm_campaign=generic)

## 🏗️ Architecture

```mermaid
flowchart LR
    Client(["📦 App / Client"]) -->|"Redis Protocol"| Proxy["Railway TCP Proxy"]
    Proxy -->|"$PORT → 6379"| App["Container\nredis:8-alpine\n(--appendonly yes)"]
    App --> Volume[("Volume\n/data")]
```

## Environment variables

```bash
REDIS_PASSWORD=replace-with-strong-password
```

`REDIS_PASSWORD` is required. The server is started with `--requirepass "$REDIS_PASSWORD"`, so Redis will not accept unauthenticated connections — set it as a generated secret in the Railway dashboard before deploying. Clients must authenticate with `AUTH <password>` (or `redis-cli -a <password>`).

## Persistence

`railway.toml` declares `requiredMountPath = "/data"` for AOF/RDB files (append-only is enabled). Attach a Railway volume to that path before production traffic — Railway will prompt for it based on this setting, but it is not created automatically.

## Health check

The Dockerfile defines a `HEALTHCHECK` that runs `redis-cli -a "$REDIS_PASSWORD" ping` on an interval, since Redis has no HTTP endpoint to probe.

## Upgrading from Redis 7.x to 8

Template releases from `0.2.0` on ship Redis 8 (`redis:8.x-alpine`); `0.1.x` shipped Redis 7.4. Existing volumes need no migration. On first start, Redis 8 loads the existing AOF/RDB files from `/data` as they are. This was tested with 7.4.12 → 8.10.3 using AOF (base RDB + incremental AOF): strings, hashes incl. per-field TTLs (`HEXPIRE`), lists, sets, sorted sets, streams, HyperLogLog, bitmaps and key TTLs were preserved.

Recommended steps:

1. Take a backup first: run `redis-cli -a "$REDIS_PASSWORD" BGSAVE`, then copy `/data` (or create a Railway volume backup).
2. Deploy the new template version and check `redis-cli -a "$REDIS_PASSWORD" INFO server | grep redis_version` and `DBSIZE`.

### Downgrade warning

**You cannot go back from 8 to 7.4 with the same volume.** As soon as Redis 8 rewrites its files (AOF rewrite, `BGSAVE`, or a regular snapshot), it writes RDB format version 15. Redis 7.4 refuses to start with `Can't handle RDB format version 15`. That is a startup error and it does not touch the data, but you would need to roll forward to 8 again. If you must stay on 7.4, keep the volume backup from step 1 and pin template release `0.1.x` (`FROM redis:7.4.12-alpine`).

### Licensing change

Redis 7.4 is available under RSALv2 or SSPLv1. From Redis 8.0, Redis is **tri-licensed: AGPLv3, RSALv2 or SSPLv1**, and you choose one. Running it unmodified as the database of your own application is normally fine under any of them. If you offer Redis itself as a service to third parties, or modify and distribute it, check the obligations of the license you pick (for example, AGPLv3 §13 source-offer requirements). See [redis.io/legal/licenses](https://redis.io/legal/licenses/). This template only contains the official image and a start command; the template files in this repository keep their own license.

## Local

```bash
docker build -t railwayapp-redis .
docker run --rm -e REDIS_PASSWORD=dev-password -p 6379:6379 railwayapp-redis
```

## 💬 Support

Questions or feedback? Visit the [template forum on Railway Central Station](https://station.railway.com/templates/redis-823f8407).

<!-- footer -->
---

[![Airbyte](https://img.shields.io/badge/Airbyte-615EFF?style=for-the-badge&logo=airbyte&logoColor=white)](https://github.com/vergissberlin/railwayapp-airbyte) [![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=apacheairflow&logoColor=white)](https://github.com/vergissberlin/railwayapp-airflow) [![CloudBeaver](https://img.shields.io/badge/CloudBeaver-382923?style=for-the-badge&logo=dbeaver&logoColor=white)](https://github.com/vergissberlin/railwayapp-cloudbeaver-ce) [![CodiMD](https://img.shields.io/badge/CodiMD-0F766E?style=for-the-badge&logo=markdown&logoColor=white)](https://github.com/vergissberlin/railwayapp-codimd) [![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)](https://github.com/vergissberlin/railwayapp-django) [![Email Service](https://img.shields.io/badge/Email%20Service-2563EB?style=for-the-badge&logo=maildotru&logoColor=white)](https://github.com/vergissberlin/railwayapp-email) [![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://github.com/vergissberlin/railwayapp-fastapi) [![Flask](https://img.shields.io/badge/Flask-3fad48?style=for-the-badge&logo=flask&logoColor=white)](https://github.com/vergissberlin/railwayapp-flask) [![Flowise](https://img.shields.io/badge/Flowise-4F46E5?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://github.com/vergissberlin/railwayapp-flowise) [![GitLab CE](https://img.shields.io/badge/GitLab%20CE-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white)](https://github.com/vergissberlin/railwayapp-gitlab) [![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)](https://github.com/vergissberlin/railwayapp-grafana) [![Home Assistant](https://img.shields.io/badge/Home%20Assistant-18BCF2?style=for-the-badge&logo=homeassistant&logoColor=white)](https://github.com/vergissberlin/railwayapp-homeassistant) [![InfluxDB](https://img.shields.io/badge/InfluxDB-22ADF6?style=for-the-badge&logo=influxdb&logoColor=white)](https://github.com/vergissberlin/railwayapp-influxdb) [![MJML](https://img.shields.io/badge/MJML-F45E43?style=for-the-badge&logo=mjml&logoColor=white)](https://github.com/vergissberlin/railwayapp-mjml) [![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)](https://github.com/vergissberlin/railwayapp-mongodb) [![Mosquitto MQTT](https://img.shields.io/badge/Mosquitto%20MQTT-3C5280?style=for-the-badge&logo=eclipsemosquitto&logoColor=white)](https://github.com/vergissberlin/railwayapp-mqtt) [![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://github.com/vergissberlin/railwayapp-mysql) [![n8n](https://img.shields.io/badge/n8n-EA4B71?style=for-the-badge&logo=n8n&logoColor=white)](https://github.com/vergissberlin/railwayapp-n8n) [![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://github.com/vergissberlin/railwayapp-nodejs) [![Node-RED](https://img.shields.io/badge/Node-RED-8F0000?style=for-the-badge&logo=nodered&logoColor=white)](https://github.com/vergissberlin/railwayapp-nodered) [![OpenSearch](https://img.shields.io/badge/OpenSearch-005EB8?style=for-the-badge&logo=opensearch&logoColor=white)](https://github.com/vergissberlin/railwayapp-opensearch) [![Open WebUI](https://img.shields.io/badge/Open%20WebUI-D68E42?style=for-the-badge&logo=ollama&logoColor=white)](https://github.com/vergissberlin/railwayapp-openwebui) [![Operately](https://img.shields.io/badge/Operately-3185FF?style=for-the-badge&logo=operately&logoColor=white)](https://github.com/vergissberlin/railwayapp-operately) [![Outerbase Studio](https://img.shields.io/badge/Outerbase%20Studio-000000?style=for-the-badge&logo=outerbase&logoColor=white)](https://github.com/vergissberlin/railwayapp-outerbase-studio) [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://github.com/vergissberlin/railwayapp-postgresql) [![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://github.com/vergissberlin/railwayapp-redis) [![TYPO3 CMS](https://img.shields.io/badge/TYPO3%20CMS-FF8700?style=for-the-badge&logo=typo3&logoColor=white)](https://github.com/vergissberlin/railwayapp-typo3)
