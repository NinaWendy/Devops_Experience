# Install Load Balancer (HAProxy)

```bash
sudo apt update

sudo apt install haproxy

sudo nano /etc/haproxy/haproxy.cfg
```

### Configure `haproxy.cfg` File to Redirect All Traffic to Active Postgres Leader

```yaml
global
    maxconn 3000

defaults
    log global
    mode tcp
    retries 2
    timeout client 30m
    timeout connect 4s
    timeout server 30m
    timeout check 5s

frontend ALL
    stats enable
    stats uri /stats
#    stats auth admin:manticoreec14

listen stats
    mode http
    bind :7000
    stats enable
    stats uri /
    stats hide-version
    stats realm Haproxy\ Statistics
#    stats auth admin:password

listen postgres
    bind :5000
    option httpchk GET / HTTP/1.1\r\nHost:\ example.com
    http-check expect status 200
    #http-check expect rstring .*
    default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions

    balance roundrobin

    server DB2_192.168.X.X:5432 192.X.X.X:5432 check port 8008
    server DB3_192.168.X.X:5432 192.X.X.X:5432 check port 8008
    server DB4_192.168.X.X:5432 192.X.X.X:5432 check port 8008

listen postgres-readonly
    bind *:6000
    timeout client  1h         # Client inactivity timeout
    timeout server  1h         # Server inactivity timeout
    timeout connect 10s        # Time to wait for a connection attempt to a server to succeed
    timeout queue   1h         # Time to wait in the queue for a connection slot
    timeout check   10s        # Time to wait for a health check response

    option httpchk GET /replica
    http-check expect status 200
    #http-check expect rstring .*
    balance roundrobin

    default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions

    server DB2_192.168.X.X:5432 192.X.X.X:5432 check port 8008
    server DB3_192.168.X.X:5432 192.X.X.X:5432 check port 8008
    server DB4_192.168.X.X:5432 192.X.X.X:5432 check port 8008
```