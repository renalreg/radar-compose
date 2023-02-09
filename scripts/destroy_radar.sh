#!/bin/bash

#--- Stop container ---#
docker compose -f docker-compose-dev.yaml down
#--- Delete data volume ---#
docker volume rm radar-compose_data
#--- Delete dump files ---#
rm radar-db/*.dump
