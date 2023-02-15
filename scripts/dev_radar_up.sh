#!/bin/bash

# ----- Password file ----- #
source ./settings/.pgpass

# ----- Schema dump ----- #
ssh $SSHUSER@$DBIP PGPASSWORD=$PGPASS \
        "pg_dump \
        --username=radar \
        --host=localhost \
        --format=custom \
        --schema-only \
        --dbname=radar \
        " \
 > ./radar-db/radar_schema.dump

# ----- Dump util tables ----- #

ssh $SSHUSER@$DBIP PGPASSWORD=$PGPASS \
"pg_dump --username=radar \
        --host=localhost \
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
        --table=specialties" \
        > ./radar-db/radar_tables.dump

# ----- Spin Radar up ----- #
docker compose -f docker-compose-dev.yaml up -d --build