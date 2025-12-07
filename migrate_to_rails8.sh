#!/bin/bash

# Rails 5.1 to Rails 8.0 Migration Script
# ========================================
# This script guides you through migrating your Rails 5.1 application to Rails 8.0
# 
# IMPORTANT: Before running this script:
# 1. Ensure you have Ruby 3.2+ installed (current: ruby -v)
# 2. Back up your database and entire project
# 3. Create a new git branch for the migration

set -e

echo "============================================"
echo "Rails 5.1 to 8.0 Migration Script"
echo "============================================"
echo ""

# Check Ruby version
RUBY_VERSION=$(ruby -v | grep -oE '[0-9]+\.[0-9]+' | head -1)
REQUIRED_VERSION="3.2"

echo "Checking Ruby version..."
if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$RUBY_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then 
    echo "ERROR: Ruby $REQUIRED_VERSION or higher is required. Current version: $RUBY_VERSION"
    echo "Please install Ruby 3.2+ before continuing."
    exit 1
fi
echo "✓ Ruby version $RUBY_VERSION is compatible"
echo ""

# Step 1: Backup files
echo "Step 1: Backing up current configuration..."
mkdir -p .rails5_backup
cp Gemfile .rails5_backup/
cp config/application.rb .rails5_backup/
cp config/boot.rb .rails5_backup/
cp config/environments/*.rb .rails5_backup/
cp config/secrets.yml .rails5_backup/ 2>/dev/null || true
cp app/views/layouts/application.html.erb .rails5_backup/
cp app/controllers/application_controller.rb .rails5_backup/
cp app/controllers/concerns/crypto.rb .rails5_backup/ 2>/dev/null || true
cp app/models/*.rb .rails5_backup/
echo "✓ Backup created in .rails5_backup/"
echo ""

# Step 2: Replace configuration files
echo "Step 2: Updating configuration files..."

# Gemfile
if [ -f Gemfile.rails8 ]; then
    cp Gemfile.rails8 Gemfile
    echo "✓ Updated Gemfile"
fi

# config/application.rb
if [ -f config/application.rb.rails8 ]; then
    cp config/application.rb.rails8 config/application.rb
    echo "✓ Updated config/application.rb"
fi

# config/boot.rb
if [ -f config/boot.rb.rails8 ]; then
    cp config/boot.rb.rails8 config/boot.rb
    echo "✓ Updated config/boot.rb"
fi

# Environment configs
if [ -f config/environments/development.rb.rails8 ]; then
    cp config/environments/development.rb.rails8 config/environments/development.rb
    echo "✓ Updated config/environments/development.rb"
fi

if [ -f config/environments/production.rb.rails8 ]; then
    cp config/environments/production.rb.rails8 config/environments/production.rb
    echo "✓ Updated config/environments/production.rb"
fi

if [ -f config/environments/test.rb.rails8 ]; then
    cp config/environments/test.rb.rails8 config/environments/test.rb
    echo "✓ Updated config/environments/test.rb"
fi

# database.yml
if [ -f config/database.yml.rails8 ]; then
    cp config/database.yml.rails8 config/database.yml
    echo "✓ Updated config/database.yml"
fi

echo ""

# Step 3: Update models
echo "Step 3: Updating models..."
if [ -f app/models/user.rb.rails8 ]; then
    cp app/models/user.rb.rails8 app/models/user.rb
    echo "✓ Updated app/models/user.rb"
fi

if [ -f app/models/article.rb.rails8 ]; then
    cp app/models/article.rb.rails8 app/models/article.rb
    echo "✓ Updated app/models/article.rb"
fi

if [ -f app/models/comment.rb.rails8 ]; then
    cp app/models/comment.rb.rails8 app/models/comment.rb
    echo "✓ Updated app/models/comment.rb"
fi

echo ""

# Step 4: Update controllers
echo "Step 4: Updating controllers..."
if [ -f app/controllers/application_controller.rb.rails8 ]; then
    cp app/controllers/application_controller.rb.rails8 app/controllers/application_controller.rb
    echo "✓ Updated app/controllers/application_controller.rb"
fi

if [ -f app/controllers/concerns/crypto.rb.rails8 ]; then
    cp app/controllers/concerns/crypto.rb.rails8 app/controllers/concerns/crypto.rb
    echo "✓ Updated app/controllers/concerns/crypto.rb"
fi

echo ""

# Step 5: Update views
echo "Step 5: Updating views..."
if [ -f app/views/layouts/application.html.erb.rails8 ]; then
    cp app/views/layouts/application.html.erb.rails8 app/views/layouts/application.html.erb
    echo "✓ Updated app/views/layouts/application.html.erb"
fi

echo ""

# Step 6: Update initializers
echo "Step 6: Updating initializers..."
if [ -f config/initializers/filter_parameter_logging.rb.rails8 ]; then
    cp config/initializers/filter_parameter_logging.rb.rails8 config/initializers/filter_parameter_logging.rb
    echo "✓ Updated config/initializers/filter_parameter_logging.rb"
fi

if [ -f config/initializers/inflections.rb.rails8 ]; then
    cp config/initializers/inflections.rb.rails8 config/initializers/inflections.rb
    echo "✓ Updated config/initializers/inflections.rb"
fi

echo ""

# Step 7: Create storage directory
echo "Step 7: Creating storage directory..."
mkdir -p storage
echo "✓ Created storage/ directory"
echo ""

# Step 8: Remove obsolete files
echo "Step 8: Removing obsolete files..."
rm -f config/secrets.yml 2>/dev/null || true
rm -rf app/assets/javascripts 2>/dev/null || true
rm -rf app/assets/stylesheets 2>/dev/null || true
echo "✓ Removed obsolete files"
echo ""

# Step 9: Clean up .rails8 files
echo "Step 9: Cleaning up temporary migration files..."
find . -name "*.rails8" -type f -delete
echo "✓ Removed .rails8 files"
echo ""

echo "============================================"
echo "Migration files updated successfully!"
echo "============================================"
echo ""
echo "NEXT STEPS (Manual):"
echo ""
echo "1. Install dependencies:"
echo "   bundle install"
echo ""
echo "2. Set up credentials (replace secrets.yml):"
echo "   bin/rails credentials:edit"
echo ""
echo "   Add the following to your credentials file:"
echo "   ---"
echo "   secret_key_base: <run 'bin/rails secret' to generate>"
echo "   "
echo "   crypto:"
echo "     aes_key: BviB6hv/YOC6KyMjM0tFQQ=="
echo "     aes_iv: IjzLM5G3clzInOjrp2pnNg=="
echo "   "
echo "   smtp:"
echo "     user_name: your_email@gmail.com"
echo "     password: your_app_password"
echo "   ---"
echo ""
echo "3. Install JavaScript dependencies:"
echo "   bin/rails importmap:install"
echo "   bin/rails turbo:install"
echo "   bin/rails stimulus:install"
echo ""
echo "4. Run database migrations:"
echo "   bin/rails db:migrate"
echo ""
echo "5. Run the update task to see additional changes:"
echo "   bin/rails app:update"
echo ""
echo "6. Start the server:"
echo "   bin/rails server"
echo ""
echo "For more information, see RAILS_8_MIGRATION_GUIDE.md"
