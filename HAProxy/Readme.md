
# apt-get install --no-install-recommends software-properties-common
# sudo add-apt-repository ppa:vbernat/haproxy-2.8
# sudo apt-get install haproxy=2.8.\*

https://haproxy.debian.net/#distribution=Ubuntu&release=focal&version=2.8

apt-get install haproxy

nano /etc/default/haproxy

ENABLED=1

`service haproxy`

`nano /etc/haproxy/haproxy.cfg`


Setup

sudo nano /etc/haproxy/haproxy.cfg

sudo systemctl restart haproxy


Install snap

sudo apt update

sudo apt install snapd
Install Core

sudo snap install core
Install Certbot

sudo snap install --classic certbot

sudo ln -s /snap/bin/certbot /usr/bin/certbot
Renew Certbot

sudo certbot renew --dry-run
 
 ---

sudo apt update
Install Certbot on Apache or NGINX:
sudo apt-get install certbot python3-certbot-apache

sudo apt-get install certbot python3-certbot-nginx

 ----

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot


---

sudo certbot certonly --standalone

sudo certbot certonly --standalone -d staging.bizwizrp.com

sudo certbot --nginx



Stop process running on port 80
run
sudo certbot certonly --standalone -d your domain

sudo cat /etc/letsencrypt/live/yourdomain.com/fullchain.pem /etc/letsencrypt/live/yourdomain.com/privkey.pem | sudo tee /etc/haproxy/certs/yourdomain.pem

Update haproxy configuration
