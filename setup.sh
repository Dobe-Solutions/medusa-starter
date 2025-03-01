#!/bin/bash
if [ ! -f ".env" ]; then
    echo "Error: Create a .env file first based on the .env.template file"
    exit 1
else
    # shellcheck source=/dev/null
    source ".env"
fi

# Start database
docker compose up -d

npx create-medusa-app@latest --db-url postgres://"$POSTGRES_USER":"$POSTGRES_PASSWORD"@localhost:5432/"$POSTGRES_DB" "$MEDUSA_PROJECT_NAME"

cd "$MEDUSA_PROJECT_NAME" || exit
npx medusa user -e "$MEDUSA_ADMIN_USER_EMAIL" -p "$MEDUSA_ADMIN_PASSWORD"
