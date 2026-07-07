ARG PG_MAJOR=18
FROM postgres:${PG_MAJOR}-alpine

# Install build dependencies, clone, compile, and clean up in one layer
RUN set -ex; \
    apk add --no-cache --virtual .build-deps \
        git \
        build-base \
        clang19-dev \
        llvm19-dev \
    ; \
    git clone --branch v0.8.4 https://github.com/pgvector/pgvector.git /tmp/pgvector; \
    cd /tmp/pgvector; \
    make; \
    make install; \
    rm -rf /tmp/pgvector; \
    apk del --no-cache .build-deps
