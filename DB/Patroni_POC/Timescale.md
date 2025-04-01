Install and configure TimescaleDB on PostgreSQL
# TimescaleDB Installation Guide

## Install the latest PostgreSQL packages
```sh
sudo apt install gnupg postgresql-common apt-transport-https lsb-release wget
```

## Run the PostgreSQL package setup script
```sh
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
```

## Add libraries for PostgreSQL development
```sh
sudo apt install postgresql-server-dev-17
```

## Add the TimescaleDB package
```sh
echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
```

## Install the TimescaleDB GPG key
```sh
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/timescaledb.gpg
```

### For Ubuntu 21.10 and earlier
```sh
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
```

## Update your local repository list
```sh
sudo apt update
```

## Install TimescaleDB
```sh
sudo apt install timescaledb-2-postgresql-17 postgresql-client-17

sudo apt install timescaledb-2-postgresql-16 postgresql-client-16
```

```sh
sudo apt-get install timescaledb-2-postgresql-14='2.6.0*' timescaledb-2-loader-postgresql-14='2.6.0*'
```

## Tune your PostgreSQL instance for TimescaleDB
```sh
sudo timescaledb-tune --quiet --yes
```

## Restart PostgreSQL
```sh
sudo systemctl restart postgresql
```

## Login to PostgreSQL as postgres
```sh
sudo -u postgres psql
```

## Set the password for postgres
```sh
\password postgres
```

## Add the TimescaleDB extension to your database

### Connect to a database on your PostgreSQL instance
```sh
psql -d "postgres://postgres:password@192.168.84.54:5432/postgres"
```

### Add TimescaleDB to the database
```sql
CREATE EXTENSION IF NOT EXISTS timescaledb;
```