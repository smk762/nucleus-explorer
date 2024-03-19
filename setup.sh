#!/bin/bash

# Get Environment Variables
source .env

# Setup for nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Get local genesis file if existing
if [ -f "${HOME}/.nucleus/config/genesis.json" ]; then
    echo "Genesis file already exists"
    cp "${HOME}/.nucleus/config/genesis.json" callisto/nucleus/genesis.json
fi

# Set up the callisto config
cp callisto/config.yaml.example callisto/config.yaml
sed -i "s/USERNAME/$POSTGRES_USER/g" callisto/config.yaml
sed -i "s/PASSWORD/$POSTGRES_PASSWORD/g" callisto/config.yaml

# Build and start the Docker containers
docker compose stop
docker-compose down -v
docker compose build && docker compose up -d

# Apply the database schema
HOST_SQL_FOLDER="callisto/database/schema"
DOCKER_SQL_FOLDER="/sql_schema"
sleep 5
for sql_file in "$HOST_SQL_FOLDER"/*.sql; do
    if [ -f "$sql_file" ]; then
        fn=$(basename "$sql_file")
        docker compose exec pgsqldb psql -U $POSTGRES_USER -d bdjuno -f "${DOCKER_SQL_FOLDER}/${fn}"
        if [ $? -ne 0 ]; then
            echo "Error executing $fn"
            docker compose stop pgsqldb
            exit 1
        else
            echo "Successfully executed $fn"
        fi
    fi
done

# Generate front end
cd big-dipper-2.0-cosmos
nvm use 18
yarn run graphql:codegen
yarn
corepack enable
yarn build --filter web-nucleus
cd -

# Apply Hasura metadata
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
cd callisto/hasura
hasura metadata apply --endpoint http://localhost:8080 --admin-secret ${HASURA_GRAPHQL_ADMIN_SECRET}
cd -

echo "Use the following command to follow the container logs:"
echo "docker compose logs -f -n 10"
