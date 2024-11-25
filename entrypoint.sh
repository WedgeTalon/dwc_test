#!/bin/sh
set -e

# Navigate to the app directory
cd /app

# Install PHP dependencies
composer install

# Install Node.js dependencies
npm install

# Build the frontend
npm run build

# Migrate the database
php artisan migrate

# Execute the original command
exec docker-php-entrypoint "$@"