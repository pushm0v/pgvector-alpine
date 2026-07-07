# Stage 1: Build phase to keep the final image clean
FROM postgres:18-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    git \
    build-base \
    clang19 \
    llvm19 \
    postgresql-dev

# Clone and compile pgvector
RUN git clone --branch v0.8.2 https://github.com /tmp/pgvector \
    && cd /tmp/pgvector \
    && make clean \
    && make OPTFLAGS="-O3" \
    && make install

# Stage 2: Final lightweight runner image
FROM postgres:18-alpine

# Copy compiled binaries from builder stage
COPY --from=builder /usr/local/lib/postgresql/vector.so /usr/local/lib/postgresql/
COPY --from=builder /usr/local/share/postgresql/extension/vector* /usr/local/share/postgresql/extension/

# Ensure the correct permissions for the postgres user
USER postgres
