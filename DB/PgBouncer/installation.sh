#!/bin/bash
# sudo apt-get install pgbouncer
# sudo systemctl status pgbouncer

sudo nano /etc/pgbouncer/pgbouncer.ini

[databases]
#dbname= host=ipaddr port=clusterport dbname=dbname
postgres = host=192.168.56.111 port=5433 dbname=postgres



1. Install PgBouncer
sudo yum install -y pgbouncer
2. Folder permissions to postgres user
chown postgres:postgres /etc/pgbouncer/ -R

3. Create Service file for PgBouncer and paste config into it
vi /usr/lib/systemd/system/pgbouncer.service
[Unit]
Description=A lightweight connection pooler for PostgreSQL
Documentation=man:pgbouncer(1)
After=syslog.target network.target
[Service]
RemainAfterExit=yes
User=postgres
Group=postgres
# Path to the init file
Environment=BOUNCERCONF=/etc/pgbouncer/pgbouncer.ini
ExecStart=/usr/bin/pgbouncer -q ${BOUNCERCONF}
ExecReload=/usr/bin/pgbouncer -R -q ${BOUNCERCONF}
# Give a reasonable amount of time for the server to start up/shut down
TimeoutSec=300
[Install]
WantedBy=multi-user.target

4. Open PgBouncer config/init file and paste the config below
[databases]
* = port=5432 auth_user=postgres
[pgbouncer]
logfile = pgbouncer.log
pidfile = pgbouncer.pid
listen_addr = 0.0.0.0
listen_port = 6432
auth_type = hba
auth_hba_file = /path/to/pg_hba.conf
admin_users = postgres
stats_users = postgres
pool_mode = session
ignore_startup_parameters = extra_float_digits
max_client_conn = 200
default_pool_size = 50
reserve_pool_size = 25
reserve_pool_timeout = 3
server_lifetime = 300
server_idle_timeout = 120
server_connect_timeout = 5
server_login_retry = 1
query_timeout = 60
query_wait_timeout = 60
client_idle_timeout = 60
client_login_timeout = 60


5. Start PgBouncer service
systemctl start pgbouncer


md5 : Default auth method for PgBouncer.

1.Run the query below.
SELECT CONCAT(‘“‘,pg_shadow.usename, ‘“ “‘, passwd, ‘“‘) FROM pg_shadow;
2.Copy output and paste into /etc/pgbouncer/users.txt
3.In ‘pgbouncer.ini’ make changes below
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt



hba : Configuration that i choose. Dont forget to delete replication db configurations in your ‘hba.conf’ file, because pgbouncer doesn’t support replication. You can use a fake ‘hba.conf’ file instead of your original file.

1. Check your pg_hba.conf and comment replication db parts. After that make sure that PgBouncer can parse it.
2. In ‘pgbouncer.ini’ make changes below
auth_type = hba
auth_file = /path/to/pg_hba.conf