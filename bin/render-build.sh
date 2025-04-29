#!/usr/bin/env bash
# exit on error
set -o errexit

# --- (On Mac, we assume Node.js and Yarn are already installed) ---

# Install Ruby Gems and Node packages
bundle install
yarn install --check-files

# Export Rails master key (if available locally)
if [ -f config/master.key ]; then
  export RAILS_MASTER_KEY=$(cat config/master.key)
else
  echo "⚠️  Warning: config/master.key not found. Rails might fail if it needs credentials."
fi

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Database setup
bundle exec rails db:migrate
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:seed:replant

