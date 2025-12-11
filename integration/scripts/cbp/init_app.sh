#!/bin/bash
set -e

mkdir -p "$HOME/.config/composer"

if [ "$CI" = "true" ]; then
  USER_ARG=""
else
  USER_ARG="-u $(id -u):$(id -g)"
fi

docker run --rm \
  $USER_ARG \
  -v "$(pwd)/submodules/cbp:/var/www/html" \
  -v "$HOME/.config/composer:/.composer" \
  -w /var/www/html \
  -e COMPOSER_AUTH \
  laravelsail/php83-composer:latest \
  composer install --ignore-platform-reqs --no-scripts

if [ ! -f "submodules/cbp/.env" ]; then
  echo "Copying .env.example to .env..."
  cp docker/cbp/.env.example submodules/cbp/.env
fi

DEFAULT_ORGANISATION_ID="6f8d3a8e-2a6e-4a21-9b41-fc7ce06a8e49" # arbitraty UUID to link the DVP client to
DVP_CLIENT_ID="006fbf34-a80b-4c81-b6e9-593600675fb1" # must match the `OIDC_CLIENT_ID` in integration/services/dvp/.env.example

docker compose up cbp cbp-pgsql -d --remove-orphans

docker compose exec cbp php artisan key:generate

docker compose exec cbp php artisan config:clear
docker compose exec cbp php artisan config:cache

docker compose exec cbp npm ci
docker compose exec cbp npm run build

docker compose exec -e DEFAULT_ORGANISATION_ID="${DEFAULT_ORGANISATION_ID}" cbp php artisan migrate:fresh --seed -v

docker compose exec cbp php artisan user:create-admin admin@example.com Admin

docker compose exec cbp php artisan client:create \
  "${DEFAULT_ORGANISATION_ID}" \
  http://localhost:9000/oidc/login,http://localhost:8801/oidc/callback \
  --client_id="${DVP_CLIENT_ID}"
