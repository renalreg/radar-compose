#!/bin/bash
set -euo pipefail

RADAR_VERSION=$(grep -m1 '^version' radar/pyproject.toml | sed -E 's/version = "(.*)"/\1/')
RADAR_CLIENT_VERSION=$(grep -m1 '"version"' radar-client/package.json | sed -E 's/.*"version": *"([^"]+)".*/\1/')

rm -rf radar-release
mkdir radar-release

# Bundle the versions so they travel with the tarballs - copy this .env
# alongside docker-compose-prod.yaml on the server so `docker compose up`
# picks the right tags automatically instead of needing them set by hand.
cat > radar-release/.env << ENVEOF
RADAR_VERSION=$RADAR_VERSION
RADAR_CLIENT_VERSION=$RADAR_CLIENT_VERSION
ENVEOF

# --- API / Admin / UKRDC importer & exporter (all share one image) --- #
docker build --target prod -t radar:"$RADAR_VERSION" ./radar
docker save radar:"$RADAR_VERSION" | gzip > radar-release/radar-"$RADAR_VERSION".tar.gz

# --- CLIENT --- #
docker build --target prod -t radar-client:"$RADAR_CLIENT_VERSION" ./radar-client
docker save radar-client:"$RADAR_CLIENT_VERSION" | gzip > radar-release/radar-client-"$RADAR_CLIENT_VERSION".tar.gz

echo "Built radar:$RADAR_VERSION and radar-client:$RADAR_CLIENT_VERSION"