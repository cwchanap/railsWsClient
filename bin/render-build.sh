#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Ruby dependencies
bundle install

# Install Bun
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Install JavaScript dependencies
bun install --frozen-lockfile

# Build TypeScript assets
bun run build

# Precompile assets (if using asset pipeline)
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Run database migrations
bundle exec rake db:migrate
