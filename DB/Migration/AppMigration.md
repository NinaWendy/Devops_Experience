# APP MIGRATION

## SOURCE HOST

### Zip app

`zip -r folder.zip /var/www/folder`

### Copy to remote host

`ssh-copy-id user@destination-server`

`scp -r folder.zip  app@x.x.x.x:/home/user/`

### Copy config file

`cd /etc/apache2/sites-available/`

`sudo cat app.com.conf`

`sudo cp /etc/apache2/sites-available/app.com.conf /home/user/`

`scp -r app.com.conf app@x.x.x.x:~`

### Stop Apache

`sudo systemctl status apache2.service`

`sudo systemctl stop apache2.service`

### Backup mysql

`head -n 50 /var/www/app.com/public_html/.env`

`mysqldump -u [uname] -p db_name > db_backup.sql`

### Copy to remote host

`scp my_database.sql  app@x.x.x.x:~`

## DESTINATION HOST

### Unzip app to /var/www/

`tar -xzvf archive_name.tar.gz -C /var/www/`

`unzip folder.zip`

### Move file

`sudo mv folder /var/www/`

### Move conf file to apache 

`cd ~`

`sudo mv app.com.conf /etc/apache2/sites-available/`

### Create db

`cat /var/www/other-app.com/public_html/.env`

`mysql -u username -p`

### Restore dump

`CREATE DATABASE db_app;`

### Restore db

`mysql -u [user] -p [database_name] < [filename].sql`

Note:ERROR 1153 (08S01) at line 11954: Got a packet bigger than 'max_allowed_packet' bytes

Under
[mysqld]
add `max_allowed_packet=100M` to /etc/mysql/my.cnf


### Update db info:

`nano /var/www/app.com/public_html/.env`

### "Enable" the website

`cd /etc/apache2/sites-available/`

`a2ensite app.com.conf`

`sudo a2dissite`

### Test syntax

`apache2ctl configtest`

### Reload apache

`sudo systemctl reload apache2`

`sudo /etc/init.d/apache2 reload`

`sudo service apache2 reload`