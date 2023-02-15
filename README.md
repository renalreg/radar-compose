# Radar Compose - DOCS UNDER CONSTRUCTION BEWARE

An all in one compose for development and production environments

## Clone the Repo

This repo includes two submodules, Radar and Radar client. To automatically initialize and update these submodules use the follow command when cloning.

<br />

```bash
$ git clone --recurse-submodules --branch adapt-for-production  https://github.com/renalreg/radar-compose.git
```

<br />

> :warning: **The branch flag is only required while this branch is in development. Remove after merge**

> :warning: **You will need to switch to the adapt-for-production branches in both submodules**

## Setting up a Dev Instance

Create a directory at the root of the project called settings. Inside this directory you will need two files

```
settings
    .env
    .pgpass
```

## .env variables

```ini
POSTGRES_PASSWORD = ""
USERPASSWORD = ''
USERNAME = ""
EMAIL = ""
FIRSTNAME = ""
LASTNAME = ""
```

POSTGRES_PASSWORD can be anything and is used to set the password in your local DB running inside a docker container.

The rest of the variables will be used to create a user locally to allow you to log into the Radar dev environment running inside the containers

> :warning: **Currently you need to supply a hashed password. The easiest way to do this is to copy the hashed password from live or staging Radar. This must be in single quotes**

## .pgpass variables

```ini
PGPASS=""
SSHUSER=""
DBIP=""
```

These are the details of the DB you are using to create your local copy, ideally use Radar live.

With these files in place run the dev_radar_up.sh script found in the scripts directory. See below for details.

<br />

# Dev Scrpits

There are few bash scripts provided with the compose repo to make regular tasks a little easier. Spinning up an existing network can be done with docker compose up or using the desktop app.

## Dev Radar Up

This script dumps the required schema and data from Radar to build a fully functional database. As well as creating the data base it includes you as a user (provided you populated the .env file) to enable logging in.

execute the following to initialize the dev environment

```bash
$ ./scripts/dev_radar_up.sh
```

## Destroy

You can run the following to kill the docker containers, remove the dump files and delete the database volume. This is useful if something goes horribly wrong during a build and you need to return radar-compose to it's original state. Config files will be left intact. To rebuild just re-run the dev radar up script.

execute the following to destroy

```bash
$ bash scripts/destroy_radar.sh
```

## Refresh

You can run the following to kill the docker containers, remove the dump files, delete the database volume, create clean dump files, rebuild and spin up the docker containers. This is useful for cleaning your test data and for updating when new items are added through Radar admin.

```bash
$ bash scripts/refresh_radar.sh
```

## Build

To build deployment packages for Radar run the build script. This will remove any old deployment packages you have if you have any, add a dist directory to the project, build the packages required inside the docker containers then copy them out ready for deployment. Follow the Radar deployment documentation to deploy.

```bash
$ bash scripts/build_radar.sh
```

<br />

# Setting up a Production Instance

Create a directory at the root of the project called settings. Inside this directory you will need three files

```
settings
    secret_key
    settings.py
    uwsgi.ini
```

## secret_key

This simply needs a long random string. No need to assign it to anything

## settings.py

```ini
SECRET_KEY = open("/path/to/secret_key_file", "rb").read()
SQLALCHEMY_DATABASE_URI = "postgres://radar:password@radar-db/radar"
SESSION_TIMEOUT = 3600
BASE_URL = "https://nww.radar.nhs.uk/#"
LIVE = True
READ_ONLY = False

CELERY_BROKER_URL = "amqp://guest@localhost//"
CELERY_RESULT_BACKEND = "rpc://"
CELERY_RESULT_PERSISTENT = False

UKRDC_SEARCH_ENABLED = False
UKRDC_SEARCH_URL = "https://nww.ukrdc.nhs.uk:9990/search"

DEFAULT_INSTRUCTIONS = "Minimum data to be completed:<br /><ul><li>Demographics</li><li>Primary Diagnosis</li><li>Consultants</li><li>Clinical Picture (if present)</li></ul>"
```

The database URI assumes a local docker container running the database. The password will need to be altered. In most cases this will need pointing at one of the remote Radar instances.

Fill in the path to the secret key file.

## uwsgi.ini

```ini
[uwsgi]
master = 1

# Bind and use the uwsgi protocol
uwsgi-socket = 0.0.0.0:5000

# Concurrency
processes = 12
threads = 2

# WSGI module location
virtualenv = /srv/radar/current
module = radar.api.app:RadarAPI()

# Run as radar
uid = radar
gid = radar

# Force uWSGI to use the latest version on reload
# http://lists.unbit.it/pipermail/uwsgi/2013-August/006314.html
binary-path = /srv/radar/current/bin/uwsgi

# Log to a file
logto = /var/log/uwsgi/api_uwsgi.log
```
