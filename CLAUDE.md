# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.1 blog application with user authentication, article management, and email verification. The application uses SQLite3 as the database, Bootstrap for styling, and TypeScript (compiled with Bun) for frontend code.

## Development Commands

### Server
```bash
bundle exec rails server       # Start development server (default: http://localhost:3000)
bin/dev                        # Start both Rails server and Bun watcher (uses Procfile.dev)
```

### TypeScript/JavaScript
```bash
bun run build                  # Build TypeScript once
bun run dev                    # Watch and rebuild TypeScript on changes
```

### Linting & Formatting
```bash
# TypeScript/JavaScript
bun run lint:ts                # Lint TypeScript files with ESLint
bun run lint:ts:fix            # Fix auto-fixable TypeScript linting issues
bun run format                 # Format TypeScript files with Prettier
bun run format:check           # Check TypeScript formatting
bun run typecheck              # Run TypeScript type checking

# Ruby
bun run lint:ruby              # Lint Ruby files with RuboCop
bun run lint:ruby:fix          # Fix auto-fixable Ruby linting issues
bundle exec rubocop            # Run RuboCop directly

# Both
bun run lint                   # Lint both TypeScript and Ruby
bun run lint:fix               # Fix both TypeScript and Ruby
```

### Pre-commit Hooks
The project uses Husky and lint-staged to automatically lint and format code before commits:
- TypeScript/JavaScript files: Auto-fixed with ESLint and formatted with Prettier
- Ruby files: Auto-fixed with RuboCop
- Hooks run only on staged files for fast performance
- Setup runs automatically on `bun install` via the `prepare` script

### Database
```bash
bundle exec rake db:migrate    # Run pending migrations
bundle exec rake db:schema:load # Load schema from db/schema.rb
bundle exec rake db:seed       # Seed the database
bundle exec rake db:reset      # Drop, create, load schema, and seed
```

### Testing
```bash
bundle exec rake test          # Run all tests
bundle exec rake test TEST=test/controllers/user_controller_test.rb  # Run specific test file
```

### Console
```bash
bundle exec rails console      # Interactive Rails console
```

### Setup
```bash
bundle install                 # Install dependencies
```

## Architecture

### Authentication & Session Management

- Session-based authentication using Rails sessions
- `session[:curr_userid]` stores the authenticated user ID
- The `Auth` concern (app/controllers/concerns/auth.rb) provides the `auth` method to protect routes
- Login/logout handled by `LoginController`
- User passwords are stored as plain text in the database (security concern)

### Encryption & Email Verification

- The `Crypto` concern (app/controllers/concerns/crypto.rb) provides AES-128 CBC encryption/decryption
- Encryption keys stored in `config/secrets.yml` (aes_key and aes_iv)
- Email verification flow:
  1. User signs up via `UserController#create`
  2. `SignUpMailer.validate_email` sends verification email with encrypted username in URL
  3. User clicks link to `UserController#validate` which decrypts username and sets `isValidate: true`
- Users must verify email before full access (enforced by `isValidate` field)

### Models & Associations

- **User**: has_many :articles, has_many :comments
  - Validations: username and password both minimum 8 characters
  - Fields: username (unique), password, email, isValidate (boolean)
- **Article**: has_many :comments (dependent: :delete_all)
  - Validations: title minimum 5 characters, text presence
  - Fields: title, text, status (boolean), user_id
- **Comment**: belongs_to :article, belongs_to :user
  - Fields: body, article_id, user_id

### Controllers

- **LoginController**: Handles login/logout via sessions and cookies
- **UserController**: User registration, email verification, admin user management
- **ArticlesController**: CRUD for articles (nested comments resources)
- **CommentsController**: CRUD for comments within articles
- **AdminController**: Admin interface (requires `/heaven` page access)
- **MainController**: Contains the "heaven" admin page

### Routing Patterns

- Nested resources: `articles/:article_id/comments` for comment CRUD
- Custom routes within resources: `articles/:article_id/toggle` for article status toggle
- Validation endpoint: `GET /validate?key=<encrypted_username>`
- Admin: `GET /admin/index` and `GET /heaven`

### Timezone Configuration

The application uses Hong Kong Time (HKT) as configured in recent commits.

## Security Considerations

- Passwords are stored in plain text - consider using bcrypt and Rails' `has_secure_password`
- The `Crypto` module encryption keys are in `config/secrets.yml` - ensure this file is in `.gitignore`
- Email verification link contains encrypted username - ensure secure key management
- The admin username 'admin' is filtered from the admin page display

## Dependencies & Stack

- Rails 8.1
- Ruby 3.2+
- SQLite3 2.x
- Bootstrap 5.3
- TypeScript 5.9.3 (compiled with Bun)
- Bun 1.3.1 (JavaScript runtime and bundler)
- Puma web server
- Propshaft (asset pipeline)
- jsbundling-rails (JavaScript bundling integration)
- Hotwire (Turbo & Stimulus)
- Action Mailer for email (SignUpMailer)

### Frontend Architecture

- TypeScript source files in `app/javascript/`
- Bun builds TypeScript to `app/assets/builds/application.js`
- Stimulus controllers for interactive components
- Turbo for SPA-like navigation
- ES modules with source maps for debugging

### Code Quality Tools

**TypeScript/JavaScript:**
- ESLint 9.x with TypeScript plugin for linting
- Prettier 3.x for code formatting
- TypeScript compiler for type checking
- Configuration: `eslint.config.js`, `.prettierrc`

**Ruby:**
- RuboCop for linting and formatting
- RuboCop Rails extension for Rails-specific rules
- Configuration: `.rubocop.yml`

**Editor Integration:**
- VSCode settings in `.vscode/settings.json`
- Format on save enabled for both TypeScript and Ruby
- Auto-fix on save for ESLint
