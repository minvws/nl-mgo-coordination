#!/bin/bash
composer install --optimize-autoloader --no-dev
echo "Installed composer dependencies ✔"

if [ ! -f "database/database.sqlite" ]; then
    touch database/database.sqlite && chmod ug+w database/database.sqlite
    echo "Created empty SQLite file ✔"
fi

php artisan migrate
echo "Migrated database ✔"

npm install && npm run build
echo "Built NPM assets ✔"

exec apache2-foreground
