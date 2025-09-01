#!/usr/bin/env bash
set -euo pipefail

ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Create a .env file first based on the .env.template file"
    exit 1
else
    source "$ENV_FILE"
fi

if [ -d "$MEDUSA_PROJECT_NAME" ]; then
    echo "Folder '$MEDUSA_PROJECT_NAME' already exists. Skipping project creation."
else
    echo "Creating Medusa project: $MEDUSA_PROJECT_NAME"
    npx create-medusa-app@latest --verbose --skip-db

    echo "" >> "$MEDUSA_PROJECT_NAME/.env"
    echo "MEDUSA_PROJECT_NAME=$MEDUSA_PROJECT_NAME" >> "$MEDUSA_PROJECT_NAME/.env"
    echo "DATABASE_URL=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB"  >> "$MEDUSA_PROJECT_NAME/.env"
    echo "POSTGRES_USER=$POSTGRES_USER" >> "$MEDUSA_PROJECT_NAME/.env"
    echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> "$MEDUSA_PROJECT_NAME/.env"
    echo "POSTGRES_DB=$POSTGRES_DB" >> "$MEDUSA_PROJECT_NAME/.env"
fi


cp medusa-files/* "$MEDUSA_PROJECT_NAME"
cd "$MEDUSA_PROJECT_NAME"
docker compose up -d

echo "Running DB migrations..."
npx medusa db:setup --db "$POSTGRES_DB"
echo "Creating admin user..."
npx medusa user -e "$MEDUSA_ADMIN_USER_EMAIL" -p "$MEDUSA_ADMIN_PASSWORD"

echo "Setup complete! Run 'cd $MEDUSA_PROJECT_NAME &&npm run dev' to start the server."