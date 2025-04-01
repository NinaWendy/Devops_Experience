## Installation

### Remove previous installation

sudo systemctl stop mysql

sudo service mysql stop
sudo killall -KILL mysql mysqld_safe mysqld

sudo apt purge mysql-server mysql-client mysql-common mysql-server-core-_ mysql-client-core-_

sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql

sudo apt autoremove

sudo apt autoclean

sudo apt update

sudo apt install mysql-server

sudo systemctl start mysql.service

## Roles

sudo mysql

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

exit

mysql -u root -p

CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';

GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'user'@'localhost' WITH GRANT OPTION;


GRANT PRIVILEGE ON database.table TO 'user'@'host';

GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost' WITH GRANT OPTION;

GRANT ALL ON source_db.\* TO 'user'@'localhost';

FLUSH PRIVILEGES;

mysql -u user -p

mysql -u user -p -h your_mysql_server_ip

## Backup

`mysqldump -u [uname] -p db_name > db_backup.sql`

## Restore dump

`mysql -u [user] -p [database_name] < [filename].sql`

Note::ERROR 1153 (08S01) at line 11954: Got a packet bigger than 'max_allowed_packet' bytes
Under
[mysqld]
add `max_allowed_packet=100M` to /etc/mysql/my.cnf
