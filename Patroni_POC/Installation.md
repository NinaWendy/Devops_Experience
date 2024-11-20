# Installation Guide

## 1. NODE 1 & 2

### Update and Upgrade
```bash
sudo apt-get update && sudo apt-get upgrade
```

### Install PostgreSQL
Refer to [Postgres Installation](./Postgres.md)

### Stop PostgreSQL
```bash
sudo systemctl stop postgresql
```

### Create Symlink
```bash
sudo ln -s /usr/lib/postgresql/14/bin/* /usr/sbin/
```

### Install pip3
```bash
sudo apt install python3-pip python3-dev libpq-dev -y
sudo pip3 install --upgrade pip
```

### Install Patroni
**IMPORTANT:** Install with sudo and without
```bash
pip install patroni
pip install python-etcd
pip install psycopg2
```

### Configure Patroni
Edit the config file:
```bash
sudo nano /etc/patroni.yml
```
Refer to [Patroni Configuration](https://github.com/patroni/patroni/blob/master/postgres0.yml)

```yaml
scope: postgres
namespace: /db/
name: db-main

restapi:
    listen: 192.168.84.54:8008
    connect_address: 192.168.84.54:8008
etcd:
    hosts: 192.168.84.53:2379

bootstrap:
    dcs:
        ttl: 30
        loop_wait: 10
        retry_timeout: 10
        maximum_lag_on_failover: 1048576
        postgresql:
            use_pg_rewind: true

    initdb:
    - encoding: UTF8
    - data-checksums

    pg_hba:
    - host replication replicator 127.0.0.1/32 md5
    - host replication replicator 192.168.84.54/0 md5
    - host replication replicator 192.168.84.56/0 md5
    - host all all 0.0.0.0/0 md5

    users:
        admin:
            password: admin
            options:
                - createrole
                - createdb

postgresql:
    listen: 192.168.84.54:5432
    connect_address: 192.168.84.54:5432
    data_dir: /mnt/data/patroni/
    pgpass: /tmp/pgpass
    authentication:
        replication:
            username: replicator
            password: password
        superuser:
            username: postgres
            password: password
    parameters:
        unix_socket_directories: '.'

tags:
    nofailover: false
    noloadbalance: false
    clonefrom: false
    nosync: false
```

`sudo mkdir -p /mnt/data/patroni/`

`sudo chown postgres:postgres /mnt/data/patroni/`

`sudo chmod 700 /mnt/data/patroni`

`sudo nano /etc/systemd/system/patroni.service`

```
[Unit]
Description=Runners to orchestrate a high-availability PostgreSQL
After=syslog.target network.target

[Service]
Type=simple

User=postgres
Group=postgres

ExecStart=/usr/local/bin/patroni /etc/patroni.yml
KillMode=process
TimeoutSec=30
Restart=no

[Install]
WantedBy=multi-user.target
```

`sudo systemctl daemon-reload`

2. ETCD

`sudo apt install etcd -y`

`sudo nano /etc/ default/etcd`

Add env variables

```
#ETCD_NAME=""
ETCD_LISTEN_PEER_URLS="http://192.168.84.53:2380,http://127.0.0.1:7001"
ETCD_LISTEN_CLIENT_URLS="http://127.0.0.1:2379, http://192.168.84.53:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.84.53:2380"
ETCD_INITIAL_CLUSTER="etcd0=http://192.168.84.53:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="primary-db"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.84.53:2379"
ETCD_ENABLE_V2="true"

```

`sudo systemctl restart etcd`

`sudo systemctl status etcd`

3. Node 1&2

Point to etcd ip in patroni config file

`sudo systemctl start patroni.service`

`sudo systemctl start postgresql`

Show members of cluster

`patronictl -c /etc/patroni.yml list`

4. HAProxy to loadbalance

`sudo apt update`

`sudo apt install haproxy`

`sudo nano /etc/haproxy/haproxy.cfg`

```

global
    maxconn 100

defaults
    log global
    mode tcp
    retries 2
    timeout client 30m
    timeout connect 4s
    timeout server 30m
    timeout check 5s

listen stats
    mode http
    bind *:7000
    stats enable
    stats uri /

frontend patroni-prod
        mode tcp
        maxconn 5000
        bind *:5432
        default_backend patroni_servers


backend patroni_servers
        mode tcp
    option httpchk OPTIONS /leader
        http-check expect status 200
        default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions

        server node1 10.10.0.181:5432 maxconn 100 check port 8008
        server node2 10.10.0.182:5432 maxconn 100 check port 8008

listen postgres
    bind *:5000
    option httpchk
    http-check expect status 200
    default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
    server node1 10.10.0.181:5432 maxconn 100 check port 8008
    server node2 10.10.0.182:5432 maxconn 100 check port 8008
```

`systemctl restart haproxy.service`

`systemctl status haproxy.service`

Access dashboard

```
    haproxy host ip:7000
```
