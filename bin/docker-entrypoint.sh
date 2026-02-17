#!/bin/bash
echo "Starting on port ${PORT:-8080}"
exec bundle exec puma -C config/puma.rb
