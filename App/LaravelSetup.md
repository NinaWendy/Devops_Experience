# LARAVEL, PHP, NGINX, HAPROXY SETUP

## Install Laravel PHP

`sudo apt update && sudo apt upgrade`

`sudo apt install -y php php-common php-cli php-gd php-mysqlnd php-curl php-intl php-mbstring php-bcmath php-xml php-zip`

`php -v`

`curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer`

`composer -v`

## Deploy App

`sudo mv ~/app /var/www/app`

`sudo chown -R www-data.www-data /var/www/travellist/storage`

`sudo chown -R www-data.www-data /var/www/travellist/bootstrap/cache`

`sudo nano /etc/nginx/sites-available/travellist`

`sudo ln -s /etc/nginx/sites-available/travellist /etc/nginx/sites-enabled/`

`sudo nginx -t`

`sudo systemctl reload nginx`

## Connect app to postgresql database

`php --ini`

```
Loaded Configuration File:         /etc/php/7.2/cli/php.ini
```

Look for Loaded Configuration File

Uncomment

```yaml
;extension=pdo_pgsql
;extension=pgsql
```

nano .env

```yaml
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=database_name
DB_USERNAME=postgres
DB_PASSWORD=your_choosen_password
```

`sudo nano app/config/database.php`

edit default

    'default' => env('DB_CONNECTION', 'mysql'),

Make sure to change search path/schema

```yaml
        'pgsql' => [
            'driver' => 'pgsql',
            'host' => env('DB_HOST', '127.0.0.1'),
            'port' => env('DB_PORT', '5432'),
            'database' => env('DB_DATABASE', 'forge'),
            'username' => env('DB_USERNAME', 'forge'),
            'password' => env('DB_PASSWORD', ''),
            'charset' => 'utf8',
            'prefix' => '',
            'schema' => 'public',
            'sslmode' => 'prefer',
```

Don't forget install php-pgsql extension. (For linux apt install php7.2-pgsql)

Make sure to add the specific php version

- `php artisan migrate: It executes all pending migrations.`

- `php artisan migrate:rollback: It undoes the last executed migration.`

- `php artisan migrate:reset: It undoes all the migrations.`

- `php artisan migrate:refresh: It undoes all the migrations and then re-executes them.`

Install some dependencies

`sudo apt-get install php8.2-pgsql`

`sudo phpenmod -v 8.2 pdo_pgsql`

`sudo systemctl restart apache2`

## Nginx

### Installation

`sudo apt update`

`sudo apt install nginx-full`

`systemctl status nginx`

Incase service is masked: `systemctl unmask name.service`

`sudo systemctl start nginx`

`sudo systemctl enable nginx`

## Haproxy



## Update php

sudo dpkg -l | grep php | tee packages.txt
sudo add-apt-repository ppa:ondrej/php # Press enter when prompted.
sudo apt update
sudo apt install php8.2 php8.2-cli php8.2-{bz2,curl,mbstring,intl}

sudo apt install php8.2-fpm

sudo apt install libapache2-mod-php8.2

sudo a2enconf php8.2-fpm

# When upgrading from older PHP version:
sudo a2disconf php8.1-fpm

## Remove old packages
sudo apt purge php8.1*


## Composer
php composer.phar install
