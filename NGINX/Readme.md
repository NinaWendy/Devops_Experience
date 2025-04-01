# NGINX

- Web Server
- Reverse Proxy
- Load balancer
- Caching content

## Installation

`sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring`

```sh
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
```

`gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg`

```sh
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
sudo tee /etc/apt/sources.list.d/nginx.list
```

```sh
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
sudo tee /etc/apt/preferences.d/99nginx
```

`sudo apt update`

`sudo apt install nginx`

## Web Server Setup

### SETUP 1

`sudo mkdir /var/www/html/mainsite.com`

`sudo mkdir /var/www/html/mainsite.com/subsite.com`

`sudo chmod -R 755 /var/www/html`

NOTE: PHP: root user and group for app, www-data for storage and bootstrap/cache

```yaml
server {
  listen 80;

  server_name mainsite;    #Need to replace With Your server IP

  root /var/www/html/mainsite.com/;
  index index.html;

  location /subsite {
  alias /var/www/html/mainsite.com/subsite.com;
  index index.html;
  }
}
```

site2

```yaml
server {
  listen 80;

  server_name subsite;    #Need to replace With Your server IP

  root /var/www/html/mainsite.com/subsite.com/;
  index index.html;
}
```

### SETUP 2

`sudo nano /etc/php/7.2/fpm/pool.d/site1.conf`

```yaml
[site1]
user = site1
group = site1
listen = /var/run/php7.2-fpm-site1.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = /
```

sudo service php7.2-fpm restart

ps aux |grep site1

sudo nano /etc/php/php7.2/fpm/conf.d/10-opcache.ini

opcache.enable=0

```yaml
server {
listen 80;

root /usr/share/nginx/sites/site1;
index index.php index.html index.htm;

server_name site1.example.org;

location / {
try_files $uri $uri/ =404;
}

location ~ \.php$ {
try_files $uri =404;
fastcgi_split_path_info ^(.+\.php)(/.+)$;
fastcgi_pass unix:/var/run/php/php7.2-fpm-site1.sock;
fastcgi_index index.php;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
include fastcgi_params;
}
}
```

### SETUP 3

sudo nano `/etc/nginx/sites-available/test.com`

```yaml
server {
listen 80;
listen [::]:80;

root /var/www/html/test.com/public;
index index.php;

server_name server_ip;

location / {
try_files $uri $uri/ =404;
}
}
```

`sudo ln -s /etc/nginx/sites-available/app.com /etc/nginx/sites-enabled/`

`sudo nginx -t`

`sudo systemctl reload nginx`

NOTE: check endpoint in browser

`http:server_ip/login`
