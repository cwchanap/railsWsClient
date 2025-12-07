# Rails 5.1 to Rails 8.0 Migration Guide

This document provides a comprehensive guide for migrating this Rails 5.1 application to Rails 8.0.

## Prerequisites

- **Ruby 3.2+** (Rails 8.0 requires Ruby 3.2.0 or newer)
- **Bundler 2.4+**
- **Git** (for version control)

### Check Your Ruby Version

```bash
ruby -v
# Should output something like: ruby 3.4.x
```

## Migration Strategy

Rails recommends upgrading one minor version at a time. However, given the significant changes between Rails 5.1 and 8.0, this guide provides a direct migration path with all necessary changes.

### Version Path
```
Rails 5.1 → 5.2 → 6.0 → 6.1 → 7.0 → 7.1 → 7.2 → 8.0
```

## Quick Migration (Automated)

Run the migration script:

```bash
chmod +x migrate_to_rails8.sh
./migrate_to_rails8.sh
```

Then follow the manual steps below.

## Detailed Migration Steps

### 1. Update Gemfile

The new `Gemfile.rails8` includes:

| Old (Rails 5.1) | New (Rails 8.0) | Notes |
|-----------------|-----------------|-------|
| `rails ~> 5.1.3` | `rails ~> 8.0` | Major upgrade |
| `sqlite3 ~> 1.3.13` | `sqlite3 >= 2.1` | New version required |
| `puma ~> 3.7` | `puma >= 6.0` | Updated |
| `sass-rails` | `propshaft` + `sassc-rails` | New asset pipeline |
| `uglifier` | Removed | Not needed with importmaps |
| `coffee-rails` | Removed | Use ES modules instead |
| `turbolinks` | `turbo-rails` | Hotwire replacement |
| N/A | `stimulus-rails` | New JS framework |
| N/A | `importmap-rails` | ES modules without bundling |
| N/A | `bootsnap` | Boot time optimization |

### 2. Configuration Changes

#### config/application.rb

```ruby
# OLD
config.load_defaults 5.1

# NEW
config.load_defaults 8.0
config.autoload_lib(ignore: %w[assets tasks])
```

#### config/boot.rb

```ruby
# Add bootsnap for faster boot times
require "bootsnap/setup"
```

#### Environment Configurations

Key changes in `config/environments/*.rb`:

| Old Setting | New Setting |
|-------------|-------------|
| `config.cache_classes` | `config.enable_reloading` (inverted logic) |
| `config.action_dispatch.show_exceptions = false` | `config.action_dispatch.show_exceptions = :rescuable` |
| N/A | `config.server_timing = true` |
| N/A | `config.active_record.verbose_query_logs = true` |

### 3. Credentials (Replacing secrets.yml)

Rails 8 uses encrypted credentials instead of `secrets.yml`.

```bash
# Edit credentials
bin/rails credentials:edit

# Or for specific environment
EDITOR="code --wait" bin/rails credentials:edit
```

Add to your credentials file:

```yaml
secret_key_base: <generate with bin/rails secret>

crypto:
  aes_key: BviB6hv/YOC6KyMjM0tFQQ==
  aes_iv: IjzLM5G3clzInOjrp2pnNg==

smtp:
  user_name: your_email@gmail.com
  password: your_app_password
```

Access in code:
```ruby
# OLD
Rails.application.config_for(:secrets)['aes_key']

# NEW
Rails.application.credentials.dig(:crypto, :aes_key)
```

### 4. JavaScript/CSS Changes

#### Asset Pipeline → Propshaft + Importmaps

Rails 8 uses:
- **Propshaft**: Simplified asset pipeline (replaces Sprockets)
- **Importmaps**: ES modules without bundling (replaces Webpacker/Sprockets JS)
- **Hotwire**: Turbo + Stimulus (replaces Turbolinks + jQuery)

#### Layout Changes

```erb
<!-- OLD -->
<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>

<!-- NEW -->
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
<%= javascript_importmap_tags %>
```

#### JavaScript Structure

```
app/
  javascript/
    application.js          # Main entry point
    controllers/
      application.js        # Stimulus application
      index.js              # Controller loader
      *_controller.js       # Your Stimulus controllers
```

### 5. Authentication Changes

#### has_secure_password (Recommended)

Rails 8 has a built-in authentication generator. For existing apps:

1. Add `bcrypt` gem (already included in new Gemfile)
2. Run migration to convert password → password_digest
3. Update User model

```ruby
class User < ApplicationRecord
  has_secure_password
  # ...
end
```

The migration `20241205000001_migrate_password_to_secure_password.rb` handles the conversion.

### 6. Model Changes

#### Normalizes (New in Rails 7.1)

```ruby
# NEW - Automatic normalization
normalizes :email, with: ->(email) { email.strip.downcase }
```

#### Association Defaults

```ruby
# dependent: :destroy is now preferred over :delete_all
has_many :comments, dependent: :destroy
```

### 7. Controller Changes

#### CSRF Protection

```ruby
# OLD (explicit)
protect_from_forgery with: :exception

# NEW (default behavior, can be removed)
# protect_from_forgery is now the default
```

#### Modern Browser Requirement (Optional)

```ruby
class ApplicationController < ActionController::Base
  # Require modern browsers (new Rails 8 feature)
  allow_browser versions: :modern
end
```

### 8. Database Changes

SQLite3 in Rails 8 uses the `storage/` directory by default:

```yaml
development:
  database: storage/development.sqlite3
```

## Breaking Changes to Address

### 1. Ruby 3.2+ Required
- Ensure all gems are compatible with Ruby 3.2+

### 2. Removed Features
- `secrets.yml` → `credentials.yml.enc`
- `config.read_encrypted_secrets` → removed
- CoffeeScript → ES modules
- Turbolinks → Turbo
- jQuery UJS → Request.js (built into Turbo)

### 3. Behavioral Changes

| Feature | Rails 5.1 | Rails 8.0 |
|---------|-----------|-----------|
| Form submission | jQuery UJS | Turbo |
| Page navigation | Turbolinks | Turbo Drive |
| Remote forms | `remote: true` | Turbo by default |
| Flash messages | Standard | Turbo Stream compatible |

### 4. Remove jQuery (If Possible)

Bootstrap 5 no longer requires jQuery. Consider:
1. Replace jQuery plugins with Stimulus controllers
2. Use native JavaScript or Turbo for AJAX

## Post-Migration Checklist

- [ ] Run `bundle install`
- [ ] Set up credentials with `bin/rails credentials:edit`
- [ ] Run `bin/rails importmap:install turbo:install stimulus:install`
- [ ] Run `bin/rails db:migrate`
- [ ] Run `bin/rails app:update` and review changes
- [ ] Run tests: `bin/rails test`
- [ ] Check for deprecation warnings in logs
- [ ] Test email functionality
- [ ] Test authentication flow
- [ ] Test all CRUD operations
- [ ] Verify JavaScript interactions work with Turbo

## Rollback Plan

If the migration fails, restore from the backup:

```bash
cp .rails5_backup/Gemfile ./
cp .rails5_backup/application.rb config/
# ... restore other files
bundle install
```

## Common Issues

### 1. "LoadError: cannot load such file"
Ensure all gems are compatible with Rails 8.

### 2. "ActionController::InvalidAuthenticityToken"
Turbo handles CSRF tokens differently. Ensure forms use Rails form helpers.

### 3. JavaScript Not Working
- Check browser console for errors
- Ensure importmap is properly configured
- Verify Stimulus controllers are properly named (`*_controller.js`)

### 4. Asset Compilation Errors
- Run `bin/rails assets:precompile` to check
- Ensure CSS files are in `app/assets/stylesheets/`

## Resources

- [Rails Upgrade Guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)
- [Hotwire Documentation](https://hotwired.dev/)
- [Turbo Handbook](https://turbo.hotwired.dev/handbook/introduction)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Propshaft](https://github.com/rails/propshaft)
- [Importmap Rails](https://github.com/rails/importmap-rails)
