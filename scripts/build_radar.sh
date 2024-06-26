#!/bin/bash

docker compose -f docker-compose-dev.yaml down
docker compose -f docker-compose-dev.yaml up -d --build

rm -rf radar-release
mkdir radar-release

# --- CLIENT --- #
docker exec -it radar-client //bin//bash //app//build.sh
CLIENT_DIST_PATH=$(docker exec radar-client //usr//bin//find //app -name radar-client*.tar.gz)
docker cp radar-client:$CLIENT_DIST_PATH ./radar-release/

# --- API --- #
docker exec -it radar-api //bin//bash -c 'source //radar//venv//bin//activate && platter build --virtualenv-version 15.1.0 -p python3 -r requirements.txt .'
API_DIST_PATH=$(docker exec radar-api //usr//bin//find //radar -name radar-*-linux-x86_64.tar.gz)
docker cp radar-api:$API_DIST_PATH ./radar-release/
