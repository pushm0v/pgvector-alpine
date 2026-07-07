FROM postgres:18-alpine

# Install pgvector from Alpine edge repositories
RUN apk add --no-cache \
    --repository=https://alpinelinux.org \
    --repository=https://alpinelinux.org \
    postgresql-pgvector
