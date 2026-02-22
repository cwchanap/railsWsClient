# syntax=docker/dockerfile:1

# Stage 1: Build assets
FROM ruby:3.2-slim AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential curl git libpq-dev libyaml-dev pkg-config unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Bun with pinned version
ENV BUN_VERSION=1.3.9
RUN curl -fsSL https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}/bun-linux-x64.zip -o bun.zip && \
    unzip bun.zip -d /usr/local && \
    rm bun.zip && \
    ln -s /usr/local/bun-linux-x64/bun /usr/local/bin/bun
ENV BUN_INSTALL="/usr/local/bun-linux-x64"
ENV PATH="$BUN_INSTALL:$PATH"

WORKDIR /app

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Install JavaScript dependencies
COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile

# Copy application code
COPY . .

# SECRET_KEY_BASE is needed for asset precompilation at build time.
# This dummy value is only used during the build and not at runtime.
ARG SECRET_KEY_BASE=dummy_secret_key_base_for_precompilation

# Build TypeScript and CSS assets
RUN bun run build && \
    bun run build:css && \
    SECRET_KEY_BASE=$SECRET_KEY_BASE bundle exec rake assets:precompile && \
    bundle exec rake assets:clean

# Remove build-only files to slim down
RUN rm -rf node_modules tmp/cache vendor/bundle/ruby/*/cache

# Stage 2: Runtime
FROM ruby:3.2-slim

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq5 curl && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r app --gid=1000 && \
    useradd -r -g app --uid=1000 --home-dir=/app --shell=/sbin/nologin app

WORKDIR /app

# Copy built application from build stage
COPY --from=build --chown=app:app /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=app:app /app /app

RUN mkdir -p tmp/pids log && \
    chown -R app:app tmp log

# Make entrypoint executable
RUN chmod +x bin/docker-entrypoint.sh

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=1
ENV PORT=8080
ENV HOME=/app
# SECRET_KEY_BASE is passed at runtime, not hardcoded
ENV SECRET_KEY_BASE

EXPOSE 8080

# Switch to non-root user
USER app

ENTRYPOINT ["bin/docker-entrypoint.sh"]
