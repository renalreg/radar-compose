#!/bin/bash
set -e 

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE radar_test;
    CREATE USER radar WITH PASSWORD 'password';
    CREATE USER radar_ro WITH PASSWORD 'password';
EOSQL

pg_restore --create -d postgres /radar_schema.dump 

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE radar TO radar;
    GRANT ALL PRIVILEGES ON DATABASE radar TO radar_ro;
    GRANT ALL PRIVILEGES ON DATABASE radar_test TO radar;
    GRANT ALL PRIVILEGES ON DATABASE radar_test TO radar_ro;
EOSQL

psql --username "$POSTGRES_USER" --dbname "radar" <<-EOSQL
    INSERT INTO users (is_admin, force_password_change, username, email, first_name, last_name, password)
    VALUES (
        true, 
        false,
        '$USERNAME', 
        '$EMAIL',
        '$FIRSTNAME', 
        '$LASTNAME', 
        '$USERPASSWORD')
EOSQL

pg_restore --disable-triggers -d radar /radar_tables.dump