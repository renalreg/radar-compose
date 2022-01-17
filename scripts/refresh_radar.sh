#!/bin/bash

#--- Password file ---#
export PGPASSFILE="./radar-db/pgpass.conf"

#--- Clean out the old ---#
docker compose down
docker volume rm radar-compose_data
rm radar-db/*.dump

#--- Schema dump ---#
pg_dump --username=radar \
        --host=10.38.181.78 \
        --format=custom \
        --schema-only \
        --dbname=radar \
        > ./radar-db/radar_schema.dump

#--- Dump util tables ---#
pg_dump --username=radar \
        --host=10.38.181.78 \
        --format=custom \
        --dbname=radar \
        --data-only \
        --table=alembic_version \
        --table=codes \
        --table=consents \
        --table=consultants \
        --table=countries \
        --table=country_ethnicities \
        --table=country_nationalities \
        --table=diagnoses \
        --table=diagnoses_codes \
        --table=drug_groups \
        --table=drugs \
        --table=ethnicities \
        --table=forms \
        --table=groups \
        --table=group_consultants \
        --table=group_diagnoses \
        --table=group_forms \
        --table=group_observations \
        --table=group_pages \
        --table=group_questionnaires \
        --table=nationalities \
        --table=nurture_sample_options \
        --table=observations \
        --table=specialties \
        > ./radar-db/radar_tables.dump

#--- Spin Radar up ---#
docker compose up -d --build