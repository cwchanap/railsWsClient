source "https://rubygems.org"

# Rails 8.0 - requires Ruby 3.2+
gem "rails", "~> 8.0"

# Database
# Note: sqlite3 2.x is compatible with Rails 8
gem "pg", "~> 1.5", group: :production
gem "sqlite3", ">= 2.1", group: %i[development test]

# Web Server
gem "puma", ">= 6.0"

# JavaScript & CSS bundling (Using Bun with TypeScript)
gem "jsbundling-rails" # JavaScript bundling with Bun
gem "propshaft"        # Asset pipeline replacement for Sprockets

# Hotwire - default for Rails 7+
gem "stimulus-rails"   # Modest JavaScript framework
gem "turbo-rails"      # SPA-like page acceleration

# Authentication - Rails 8 includes built-in authentication generator
# Run: bin/rails generate authentication
gem "bcrypt", "~> 3.1" # Required for has_secure_password

# Background Jobs - Rails 8 solid suite (optional)
# gem "solid_queue"    # Database-backed Active Job backend
# gem "solid_cache"    # Database-backed cache store
# gem "solid_cable"    # Database-backed Action Cable adapter

# Build JSON APIs with ease
gem "jbuilder"

# Reduces boot times through caching
gem "bootsnap", require: false

# CSS Framework - Using Tailwind CSS via Bun

# Windows/JRuby timezone data
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "brakeman", require: false # Security vulnerability scanner
  gem "debug", platforms: %i[mri windows mswin]
  gem "rubocop-rails", require: false # Code style
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
