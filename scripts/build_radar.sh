#!/bin/bash

#--- Password file ---#
export PGPASSFILE="./radar-db/pgpass.conf"

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

# #--- Clone Radar ---#
git clone https://github.com/renalreg/radar.git && git -C ./radar checkout Dockerise
git clone https://github.com/renalreg/radar-client.git && git -C ./radar-client checkout Dockerise

#--- Spin Radar up ---#
docker compose up -d --build