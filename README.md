# Radar Compose - DOCS UNDER CONSTRUCTION BEWARE

An all in one compose for development and production environments

### .env variables

An example/template .env file can be found in .env.template

```none
## ----- Database ----- ##
## ----- Dev only ----- ##

POSTGRES_PASSWORD = password
USERPASSWORD = password
USERNAME = sponge.bob
EMAIL = sponge.bob@email.com
FIRSTNAME = Spongebob
LASTNAME = Squarepants

## ----- Flask apps ----- ##

SECRET_KEY = 'SECRET'
SQLALCHEMY_DATABASE_URI = 'postgres://username:password@route/db'

DEBUG = True

SESSION_TIMEOUT = 3600
BASE_URL = 'http://address:port'
LIVE = False
READ_ONLY = False

UKRDC_SEARCH_ENABLED = True
UKRDC_SEARCH_URL = 'http://address:port/search'
UKRDC_SEARCH_TIMEOUT = 60

UKRDC_EXPORTER_URL = 'http://address:port/importandregister'
UKRDC_EXPORTER_STATE = '/tmp/exporter.state'

CELERY_BROKER_URL = 'amqp://guest@localhost//'
CELERY_RESULT_BACKEND = 'rpc://'
CELERY_RESULT_PERSISTENT = False

DEFAULT_INSTRUCTIONS = 'Minimum data to be completed:<br /><ul><li>Demographics</li><li>Primary Diagnosis</li><li>Consultants</li><li>Clinical Picture (if present)</li></ul>'

## ----- Client ----- ##

CLIENT_BASE = '/'
RADAR_CLIENT_HOST='client'
RADAR_CLIENT_PORT=****

## ----- NGINX ----- ##

PORT=****
```

## Deploying Production

Under construction

# Deploying Development

## System Requirements

The build setup assumes you have the following software available

    * Docker
    * pg_dump
    * bash

## Build Setup

### Clone

Cloning this repo to C: drive. This repo is untested on networked drives.

### Configure

A .env and pgpass.conf are included and provide comments on how they should be populated.

## Scripts

There are few bash scripts provided with the compose repo to make regular tasks a little easier. Spinning up an existing network can be done with docker compose up or using the desktop app.

### Build

This script dumps the required schema and data from Radar to build a fully functional database. As well as creating the data base it includes you as a user (provided you populated the .env file) to enable logging in. It grabs both the Radar repos and adds them as submodules so that VSCode recognizes them as separate repos and enables the use of the git tools.

execute the following to build

```bash
$ ./scripts/build_radar.sh
```

### Destroy

You can run the following to kill the docker containers, remove Radar and Radar client repos, remove the dump files and delete the database volume. This is useful if something goes wrong during a build and you need to return radar-compose to it's original state. Config files will be left intact. To rebuild just re-run the build script.

execute the following to destroy

```bash
$ bash scripts/destroy_radar.sh
```

### Refresh

You can run the following to kill the docker containers, remove the dump files, delete the database volume, create clean dump files, rebuild and spin up the docker containers. This is useful for cleaning your test data and for updating when new items are added through Radar admin.

```bash
$ bash scripts/refresh_radar.sh
```

### Deploying

The easiest way to deploy is bashing into the corresponding containers and following the existing documentation for deployment for that repo.

execute the following to bash into a container. This assumes a windows local OS.

```bash
$ winpty docker exec -it [container name] //bin//bash
```

This build script is intended to act as a single command development build for Radar. To facilitate this it begins by creating two dump files from an existing Radar database. The first is a schema dump and the second grabs data only from a list of specific tables that are predominantly used for lookups. Example include cohorts and forms. No patient data is dumped.

These files are copied to a postgres docker container and are used to create a bare bones Radar database. It also adds you as a user provided you supply the necessary information to enable login.

Both Radar and Radar client are cloned and containers created. Radar is spun up in two containers one for radar-api and one for radar-admin. Four containers should be running in total.
