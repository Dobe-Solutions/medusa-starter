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

# download newest examples
if [ ! -d "examples" ]; then
    git clone https://github.com/medusajs/examples.git
    cd examples || exit
else
    cd examples && git pull
fi

# get all available example projects
examples=()
for dir in */; do
    # Ensure it's a directory
    if [ -d "$dir" ]; then
        examples+=("$(basename "$dir")")
    fi
done

echo "Please choose an example to setup:"
select example in "${examples[@]}"; do

    echo "You selected: $example"
    cd "$example" || exit
    cp .env.template .env
    sed -i "s|^DATABASE_URL=.*|DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:5432/${POSTGRES_DB}|" .env
    npm install
    npx medusa db:setup --db "$POSTGRES_DB" --no-interactive || true
    npx medusa user -e "$MEDUSA_ADMIN_USER_EMAIL" -p "$MEDUSA_ADMIN_PASSWORD"

    break

done
