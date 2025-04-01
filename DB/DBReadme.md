# DATABASE

## Create user

`CREATE USER username WITH PASSWORD 'password';`

`createuser --interactive`

`CREATE ROLE username WITH LOGIN PASSWORD 'pass';`

Note: Role cannot login

## Create role

`select \* from pg_roles;`

`CREATE ROLE readwrite;`

## List roles

`\du`

## Grant permissions

`GRANT CONNECT ON DATABASE db_name TO role_name;`

`GRANT USAGE, CREATE ON SCHEMA schema_name TO role_name;`

`GRANT SELECT, UPDATE, DELETE, INSERT ON ALL TABLES IN SCHEMA schema_name TO role_name`

## Grant privilege to users

`GRANT role_name TO username`;

## Create Database

`CREATE DATABASE db_name;`

## List database

`\l`

## Use a particular db

`\c database_name`

## Create table

`CREATE TABLE table_name;`

## List tables

`\dt`

## Insert data into table

`show search_path;`

## When you do not specify schema it uses public schema. For security reasons:

`REVOKE CREATE ON SCHEMA public FROM PUBLIC;`

`REVOKE ALL ON SCHEMA public FROM PUBLIC;`

## PITR (Point In Time Recovery)

Enable PostgreSQL Archive Logging

`sudo -H -u postgres mkdir /var/lib/postgresql/pg_log_archive`

`sudo nano /etc/postgresql/17/main/postgresql.conf`

```yaml
wal_level = replica
archive_mode = on

archive_command = 'test ! -f /var/lib/postgresql.pg_log_archive/%f && cp %p /var/lib/postgresql/pg_log_archive/%f'
```

Restart

`sudo systemctl restart postgreql.service`

## Archive the logs

`psql -c "select pg_switch_wal();"`

## Backup database

`pg_basebackup -Ft -D /var/lib/postgresql/db_file_backup`

## Stop database and destroy data

`sudo systemctl stop postgresql.service`

`rm /var/lib/postgresql/17/main/\* -r`

## Restore database

`tar xvf /var/lib/postgresql/db_file_backup/base.tar -C /var/lib/postgresql/10/main/`

`tar xvf /var/lib/postgresql/db_file_backup/pg_wal.tar -C /var/lib/postgresql/10/main/pg_wal`

## Add recovery.conf

`nano /var/lib/postgresql/17/main/recovery.conf`

```yaml
restore_command = 'cp /var/lib/postgresql/pg_log_archive/%f %p'
```

## Start Database

`sudo systemctl start postgresql.service`

## PG_DUMP

### Backup

pg_dump -v database_name > /postgres/backup/db.sql

pg_dump -v database_name -f /postgres/backup/db.sql

pg_dump -v -U postgres -W -F t database_name > /postgres/backup/db.tar

### Restore

`createdb -T template0 restored_db`

`psql restored_db < /postgres/backup/db.sql`

### Backup all

`pg_dumpall > /postgres/backup/all.sql`

## Indexing

Btrees and B+ Trees

## Connection Pooling
