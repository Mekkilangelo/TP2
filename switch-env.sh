#!/bin/bash

# Script pour basculer entre Blue et Green
# Usage: ./switch-env.sh [blue|green]

if [ $# -eq 0 ]; then
    echo "Usage: $0 [blue|green]"
    exit 1
fi

TARGET_ENV=$1

if [ "$TARGET_ENV" != "blue" ] && [ "$TARGET_ENV" != "green" ]; then
    echo "Error: Environment must be 'blue' or 'green'"
    exit 1
fi

echo "Switching to $TARGET_ENV environment..."

# Mettre à jour la configuration Nginx
if [ "$TARGET_ENV" = "blue" ]; then
    sed -i '' 's/server webapp-green:80;/server webapp-blue:80;/' nginx.conf
else
    sed -i '' 's/server webapp-blue:80;/server webapp-green:80;/' nginx.conf
fi

# Recharger Nginx
docker-compose exec nginx nginx -s reload

echo "Switched to $TARGET_ENV environment successfully!"
