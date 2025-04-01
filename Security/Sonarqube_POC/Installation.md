## Prerequisite

### Install Java 
```
   sudo apt update
   sudo apt install default-jdk
   specific version "sudo apt install openjdk-#-jdk"
   sudo apt update
   sudo apt install default-jre
```
Set JAVA_HOME Env
```
sudo update-alternatives --config java
sudo nano /etc/environment
```

### Install Postgres 17

```sh
sudo apt update
sudo apt upgrade

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null

sudo apt update
sudo apt-get -y install postgresql postgresql-contrib
sudo systemctl enable postgresql
```
- Now, let's configure PostgreSQL:


- Switch to the PostgreSQL user:

```sh
sudo passwd postgres

su - postgres
```

- Create a new user and database for SonarQube:

```sh
createuser sonar
```

```sh
psql
```

- Inside the PostgreSQL shell, set a password for the sonar user:

```sh
ALTER USER sonar WITH ENCRYPTED password 'sonar';

CREATE DATABASE sonarqube OWNER sonar;

grant all privileges on DATABASE sonarqube to sonar;

\q
```


### Increase Limits

```sh
sudo vim /etc/security/limits.conf
```

```yaml
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
```
```
sudo vim /etc/sysctl.conf
```
```yaml
vm.max_map_count = 262144
```

```sh
sudo reboot
```

## Install sonarqube

```sh
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip
```

Extract the SonarQube package:

```sh
unzip sonarqube-10.5.1.90531.zip
sudo mv sonarqube-10.5.1.90531 /opt/sonarqube
```

Create a SonarQube user:
```sh
sudo groupadd sonar
sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar
```

Change ownership of the SonarQube directory:

```sh
sudo chown -R sonar:sonar /opt/sonarqube
```

Now, let's configure SonarQube

Edit the SonarQube configuration file:

```sh
sudo nano /opt/sonarqube/conf/sonar.properties
```

Uncomment and set the following properties:

```yaml
sonar.jdbc.username=sonar
sonar.jdbc.password=your_password
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
```

Create service for Sonarqube

```sh
sudo nano /etc/systemd/system/sonar.service
```

```yaml
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
```
Start Sonarqube and Enable service

```sh
sudo systemctl start sonar

sudo systemctl enable sonar

sudo systemctl status sonar

sudo tail -f /opt/sonarqube/logs/sonar.log
```

## Install jenkins

Refer to Jenkins installation

## Intergration

