# syntax=docker/dockerfile:1

# Stage 1: Build assets
FROM ruby:3.2-slim AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential curl git libpq-dev libyaml-dev pkg-config unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL="/root/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

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

WORKDIR /app

# Copy built application from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

RUN mkdir -p tmp/pids log

# Make entrypoint executable
RUN chmod +x bin/docker-entrypoint.sh

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=1
ENV PORT=8080
ENV SECRET_KEY_BASE=3f9df7a4b6d186a338b4fb068b273707b517971edef702e9653cea07cb59250104d3e10c98b4fb44f603b00d8c9686e400ee1b31d99389cc25c7e0bf83cdd8f7

EXPOSE 8080

CMD ["bash", "-c", "bundle exec rake db:prepare && exec bundle exec puma -C config/puma.rb"]
