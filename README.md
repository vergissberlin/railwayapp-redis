# Redis for railway.app

![Template Header](./template-header.svg)

Deploy Redis 7 on Railway with the official Docker image.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template)

## Persistence

Mount a Railway volume at `/data` for AOF/RDB files (append-only is enabled).

## Local

```bash
docker build -t railwayapp-redis .
docker run --rm -p 6379:6379 railwayapp-redis
```

<!-- footer -->
