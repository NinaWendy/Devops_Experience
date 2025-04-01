Generate a ssl certificate for a domain

#define hosts

acl host_monitoringdid hdr(host) -i monitoringdid.ecs.africa
acl host_uptimedid hdr(host) -i uptimedid.ecs.africa

# Direct hosts to backend

use_backend monitoringdid if host_monitoringdid
use_backend uptimedid if host_uptimedid

backend uptimedid
server uptimedid 172.18.8.188:3001

backend letsencrypt-backend
server letsencrypt 127.0.0.1:54321

mkdir /etc/haproxy/certs/

haproxy -c -f /etc/haproxy/haproxy.cfg

`sudo certbot certonly --standalone --preferred-challenges http --http-01-port 54321 -d domain_name`

`sudo DOMAIN='domain_name' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem`

check logs incase of error
`sudo journalctl -u haproxy.service`
