
Log in to the PostgreSQL shell.

$ sudo -u postgres psql
Create the sonaruser role.

postgres=# CREATE ROLE sonaruser WITH LOGIN ENCRYPTED PASSWORD 'your_password';
Create the sonarqube database.

postgres=# CREATE DATABASE sonarqube;
Grant all privileges on the sonarqube database to the sonaruser role.

postgres=# GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonaruser;

sudo mv sonarqube-9.9.6.92038/ /opt/sonarqube

sudo adduser --system --no-create-home --group --disabled-login sonarqube

#important
sudo chown sonarqube:sonarqube /opt/sonarqube -R

sudo nano /opt/sonarqube/conf/sonar.properties

sudo nano /etc/sysctl.conf

sudo nano conf/sonar.properties

#IMPORTANT
export SONAR_JAVA_PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin/java"

sudo nano /etc/environment

source /etc/environment

bin/linux-x86-64/sonar.sh start

sudo systemctl enable sonarqube

#Important
ExecStart=/bin/nohup /usr/lib/jvm/java-17-openjdk-amd64/bin/java -Xms32m -Xmx32m -Djava.net.preferIPv4Stack=true -jar /opt/sonarqube/lib/son>

Restart=on-failure
