#!/bin/bash

#--- Stop container ---#
docker compose -f docker-compose-dev.yaml down
#--- Delete data volume ---#
docker volume rm radar-compose_data
#--- Remove Radar repos ---#
rm -rf radar
rm -rf radar-client
#--- Delete dump files ---#
rm radar-db/*.dump
