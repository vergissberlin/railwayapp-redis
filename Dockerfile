FROM redis:7-alpine

EXPOSE 6379

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=5 \
  CMD redis-cli -a "$REDIS_PASSWORD" ping || exit 1

CMD ["sh", "-c", "redis-server --appendonly yes --requirepass \"$REDIS_PASSWORD\""]
