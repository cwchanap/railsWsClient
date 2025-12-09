source "https://rubygems.org"

# Rails 8.0 - requires Ruby 3.2+
gem "rails", "~> 8.0"

# Database
# Note: sqlite3 2.x is compatible with Rails 8
gem "sqlite3", ">= 2.1"

# Web Server
gem "puma", ">= 6.0"

# JavaScript & CSS bundling (Using Bun with TypeScript)
gem "propshaft"        # Asset pipeline replacement for Sprockets
gem "jsbundling-rails" # JavaScript bundling with Bun

# Hotwire - default for Rails 7+
gem "turbo-rails"      # SPA-like page acceleration
gem "stimulus-rails"   # Modest JavaScript framework

# Authentication - Rails 8 includes built-in authentication generator
# Run: bin/rails generate authentication
gem "bcrypt", "~> 3.1"  # Required for has_secure_password

# Background Jobs - Rails 8 solid suite (optional)
# gem "solid_queue"    # Database-backed Active Job backend
# gem "solid_cache"    # Database-backed cache store
# gem "solid_cable"    # Database-backed Action Cable adapter

# Build JSON APIs with ease
gem "jbuilder"

# Reduces boot times through caching
gem "bootsnap", require: false

# CSS Framework
gem "bootstrap", "~> 5.3"
gem "sassc-rails"

# Windows/JRuby timezone data
gem "tzinfo-data", platforms: [:windows, :jruby]

group :development, :test do
  gem "debug", platforms: [:mri, :windows, :mswin]
  gem "brakeman", require: false  # Security vulnerability scanner
  gem "rubocop-rails", require: false  # Code style
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.6.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
