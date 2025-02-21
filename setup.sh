#!/bin/bash

MEDUSA_PROJECT_NAME=my-medusa-store
MEDUSA_ADMIN_USER_EMAIL=medusa@example.com

docker compose up -d
npx create-medusa-app@latest --db-url "postgres://medusa:medusa@localhost:5432/medusa" $MEDUSA_PROJECT_NAME
cd $MEDUSA_PROJECT_NAME
npx medusajs/medusa-cli user -e $MEDUSA_ADMIN_USER_EMAIL -p medusa
