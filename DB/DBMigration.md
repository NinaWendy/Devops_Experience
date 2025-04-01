## Postgres

Make sure postgres is installed and running
1. The user is supposed to be a super user
2. The user should have all privileges on the database

## MySQL

Make sure mysql is installed and running
Create a dedicated user that has all privileges on the database

## PGLOADER

### Install

`sudo apt update`

`sudo apt install sbcl unzip libsqlite3-dev gawk curl make freetds-dev libzip-dev`

`curl -fsSLO https://github.com/dimitri/pgloader/archive/v3.6.2.tar.gz`

`tar xvf v3.6.2.tar.gz`

`cd pgloader-3.6.2/`

`make pgloader`

`sudo mv ./build/bin/pgloader /usr/local/bin/`

`pgloader --version`

### Run the migration

`sudo pgloader mysql://bizwiz:$MSQ_PASS@127.0.0.1/bizwizkanini?useSSL=false postgresql://bizwiz:$PSQ_PASS@127.0.0.1/bizwizkanini`

## Possible errors

#### ERROR 1

```yaml
KABOOM!
FATAL error: Failed to connect to pgsql at "10.10.125.200" (port 9999) as user "user2": 10 fell through ECASE expression. Wanted one of (0 2 3 4 5 6 7 8).
Date/time: 2020-07-09-11:56!
```

#### Steps to fix issue

- Edit postgresql.conf, find the line password_encryption = scram-sha-256, change it to password_encryption = md5.

- Edit pg_hba.conf, change all the scram-sha-256 to md5 for the listening address.

- Restart the postgresql server.

- Launch psql, change the password for the user I used for import \password import_user.

- Run pgloader with the new password.

The database should be imported now.

- Change password_encryption back to scram-sha-256 and authentication method back to scram-sha-256 in pg_hba.conf and restart the database server.

- Reset the password again

#### ERROR 2
```yaml
The problem is that currently pgloader doesn't support caching_sha2_password authentication plugin, which is default for MySQL 8, whereas older MySQL versions use mysql_native_password plugin. The corresponding issue is opened on Github.

Based on this comment, the workaround here is to edit my.cnf (if you don't know where it is, look here) and in [mysqld] section add

default-authentication-plugin=mysql_native_password
Then restart your MySQL server and execute:

ALTER USER 'youruser'@'localhost' IDENTIFIED WITH mysql_native_password BY 'yourpassword';
```
 
#### ERROR 3

```yaml
Mysql to postgres Migration pgloader "ERROR mysql: 76 fell through ECASE expression"
```

- Compile from source

#### ERROR 4

Converting enum type between mysql and postgresql

```
ALTER TABLE wa_approve_termination
MODIFY COLUMN notice_given ENUM('On', 'Off') NOT NULL, MODIFY COLUMN cleared ENUM('On', 'Off') NOT NULL,
MODIFY COLUMN eligible_for_rehire ENUM('On', 'Off') NOT NULL;
```

See other migration options

https://www.digitalocean.com/community/tutorials/how-to-migrate-mysql-database-to-postgres-using-pgloader 


Check for ' '
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE 
    -> FROM information_schema.COLUMNS 
    -> WHERE TABLE_SCHEMA = 'schemaname' 
    -> AND COLUMN_TYPE LIKE "%''%";