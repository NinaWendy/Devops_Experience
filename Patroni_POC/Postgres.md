sudo apt install curl ca-certificates
# PostgreSQL Installation and Upgrade Guide

## Installation

```sh
    sudo apt install curl ca-certificates
```

1. Create the directory for PostgreSQL common files:
    ```sh
    sudo install -d /usr/share/postgresql-common/pgdg
    ```

2. Download the PostgreSQL signing key:
    ```sh
    sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
    ```

3. Add the PostgreSQL APT repository:
    ```sh
    sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    ```

4. Update the package lists:
    ```sh
    sudo apt update
    ```

5. Install PostgreSQL:
    ```sh
    sudo apt -y install postgresql-14
    ```

## Checking Installed Versions

To find the installed PostgreSQL versions on your machine, run the following commands:
```sh
dpkg --get-selections | grep postgres
```

```sh
pg_lsclusters
```

## Upgrading PostgreSQL

When PostgreSQL packages are installed, they create a default cluster for you to use. We need to rename the new PostgreSQL cluster so that when we upgrade the old cluster, the names won't conflict.

1. Stop the PostgreSQL service:
    ```sh
    sudo service postgresql stop
    ```

2. Rename the new PostgreSQL cluster:
    ```sh
    sudo pg_renamecluster newversion main main_pristine
    ```

3. Upgrade the old PostgreSQL cluster:
    ```sh
    sudo pg_upgradecluster oldversion main
    ```
