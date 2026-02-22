#!/bin/bash
echo "Starting on port ${PORT:-8080}"

# Run database migrations only if not in a multi-instance environment
# For production with multiple instances, consider running migrations
# as a separate pre-deploy step to avoid race conditions.
if [ "${SKIP_MIGRATIONS}" != "true" ]; then
  bundle exec rake db:prepare
fi

exec bundle exec puma -C config/puma.rb
