# Radar Development Environment

A collection of files required to create a development environment for Radar including a database with required lookup tables

### Overview

This build script is intended to act as a single command development build for Radar. To facilitate this it begins by creating two dump files from an existing Radar database. The first is a schema dump and the second grabs data only from a list of specific tables that are predominantly used for lookups. Example include cohorts and forms. No patient data is dumped.

These files are copied to a postgres docker container and are used to create a bare bones Radar database. It also adds you as a user provided you supply the necessary information to enable login.

Both Radar and Radar client are cloned and containers created. Radar is spun up in two containers one for radar-api and one for radar-admin. Four containers should be running in total. 

## System Requirements

The build setup assumes you have the following software available 

    * Docker
    * pg_dump
    * bash


## Build Setup

### Clone

Cloning inside a Radar directory is optional but is assumed for documentation purposes.

### Configure

A .env and pgpass.conf are included and provide comments on how the should be populated.

### Build

```bash
$ bash scripts/build_radar.sh
```

This should leave you with the following file structure

RADAR
|   
\---radar-compose
    |   .env
    |   .gitignore
    |   docker-compose.yaml
    |   LICENSE
    |   README.md
    |   rebuild_radar.sh
    |   
    +---radar            
    +---radar-client        
    \---radar-db
            build_radar.sh
            Dockerfile
            initdb_script.sh
            pgpass.conf
            radar_schema.dump
            radar_tables.dump

### Destroy

You can run the following to kill the docker containers, remove radar and radar client repos, remove the dump files and delete the database volume. This is useful if something goes wrong during a build and you need to return radar-compose to it's original state. Config files will be left intact.

```bash
$ bash scripts/destroy_radar.sh
```

### Refresh

You can run the following to kill the docker containers, remove the dump files, delete the database volume, create clean dump files, rebuild and spin up the docker containers. This is useful for cleaning your test data and for updating when new items are added through Radar admin.

```bash
$ bash scripts/refresh_radar.sh
```