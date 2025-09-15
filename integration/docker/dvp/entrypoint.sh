#!/bin/bash

sed -ex

cp .env.example .env
echo "Copied .env.example to .env ✔"

composer install --optimize-autoloader --no-dev
echo "Installed composer dependencies ✔"

if ! grep -q '^APP_KEY=' .env || grep -q '^APP_KEY=$' .env; then
    echo "Create APP_KEY ✔"
    php artisan key:generate
fi

if [ ! -f "database/database.sqlite" ]; then
    touch database/database.sqlite && chmod ug+w database/database.sqlite
    echo "Created empty SQLite file ✔"
fi

php artisan migrate
echo "Migrated database ✔"

npm install && npm run build
echo "$(date '+%Y-%m-%d %H:%M:%S') - Built NPM assets ✔"


exec apache2-foreground
