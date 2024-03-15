#!/bin/bash
source .env

# make sure you select the correct branch inside the BDJuno repository to view the correct schema for the chain you want to parse.
HOST_SQL_FOLDER="callisto/database/schema"
DOCKER_SQL_FOLDER="/sql_schema"

docker compose up -d pgsqldb
sleep 5

# Iterate over each SQL file in the folder
for sql_file in "$HOST_SQL_FOLDER"/*.sql; do
    if [ -f "$sql_file" ]; then
        fn=$(basename "$sql_file")
        # Execute the SQL file using Docker Compose
        docker-compose exec pgsqldb psql -U $POSTGRES_USER -d bdjuno -f "${DOCKER_SQL_FOLDER}/${fn}"
        
        # Check the exit status
        if [ $? -ne 0 ]; then
            echo "Error executing $fn"
            docker-compose stop pgsqldb
            exit 1
        else
            echo "Successfully executed $fn"
        fi
    fi
done
docker-compose stop pgsqldb
