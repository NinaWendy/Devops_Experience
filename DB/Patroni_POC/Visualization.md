# Setting Up Prometheus and Grafana for a Patroni cluster

## Installing Prometheus


Creating Service Users:

`sudo useradd --no-create-home --shell /bin/false prometheus`

Make the appropriate folders for storing Prometheus files and data. We’ll make a directory in /etc for Prometheus’ configuration files and one in /var/lib for its data in accordance with conventional Linux practices.
```sh
 sudo mkdir /etc/prometheus
 sudo mkdir /var/lib/prometheus
```

Set the Prometheus user as the owner of the user and group accounts for the new directories.

```sh
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
```

1.1. Download Prometheus

Grab the latest release from the official website https://prometheus.io/download/ or use wget

```sh
wget https://github.com/prometheus/prometheus/releases/download/v2.53.3/prometheus-2.53.3.linux-amd64.tar.gz
```

1.2. Extract and Move Files

Unpack the downloaded archive and Copy the two binaries to the /usr/local/bin directory.

```sh
tar xvzf prometheus-2.53.3.linux-amd64.tar.gz

sudo cp prometheus-2.53.3.linux-amd64/prometheus /usr/local/bin/

sudo cp prometheus-2.53.3.linux-amd64/promtool /usr/local/bin/

```

Set the user and group ownership on the binaries to the Prometheus user created.

```sh
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
```

The consoles and console_libraries folders should now be copied to /etc/prometheus.

```sh
sudo cp -r prometheus-2.53.3.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.53.3.linux-amd64/console_libraries /etc/prometheus
```

The folders should have user and group ownership granted to the Prometheus user.

If the -R option is used, the ownership of the directory’s files will also be set.

```sh
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
```
Finally, delete any remaining files from your home directory that are no longer required. (optional)

` rm -rf prometheus-2.43.0.linux-amd64.tar.gz prometheus-2.43.0.linux-amd64`

1.3. Create Configuration File

Create or edit the `prometheus.yml` file to define scrape configurations:

```sh
cd /etc/prometheus
sudo vim prometheus.yml
```

```yaml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['192.168.56.125:9090']

  - job_name: 'postgres_exporter'
    metrics_path: '/metricsRestart=always'
    static_configs:
    - targets: ['192.168.56.125:9187']

  - job_name: 'patroni'
    metrics_path: '/metrics'
    static_configs:
    - targets: ['192.168.56.125:8008']
```
change the configuration file’s user and group ownership to the Prometheus user.

`sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml`

1.4. Create Prometheus Service File
Define a systemd service for Prometheus:

```sh
sudo nano /etc/systemd/system/prometheus.service
```

```yaml
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```
1.5. Start and Check Prometheus Service
Don’t forget to open port 9090 if your firewall is enable.

```sh
sudo systemctl daemon-reload

sudo systemctl enable --now prometheus.service

sudo systemctl status prometheus.service
```





## Integration of PostgreSQL Exporter

 Download the relevant Postgres Exporter binary.

```sh
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.15.0/postgres_exporter-0.15.0.linux-amd64.tar.gz
```

Replace vx.x.x with the version you’d like to install. This guide may become stale so it’s best to check the Postgres Exporter Releases page https://github.com/prometheus-community/postgres_exporter/releases for the latest stable version.

```sh
tar xvzf postgres_exporter-0.15.0.linux-amd64.tar.gz

sudo cp postgres_exporter-0.15.0.linux-amd64/postgres_exporter /usr/local/bin
```

Create the necessary env file

`sudo mkdir /etc/postgres_exporter`

`sudo nano /etc/postgres_export/.env`

```
DATA_SOURCE_NAME="postgresql://postgres:postgres@192.168.84.54:5432/?sslmode=disable"
```


2.2. Create Service File
Define a systemd service for the PostgreSQL Exporter:

`sudo nano /etc/systemd/system/postgres-exporter.service`

```yaml
[Unit]
Description=Prometheus exporter for Postgresql
Wants=network-online.target
After=network-online.target

[Service]
User=postgres
Group=postgres
Type=simple
EnvironmentFile=/etc/postgres_exporter/.env

ExecStart=/usr/local/bin/postgres_exporter \
    --web.listen-address=:9187 \
    --web.telemetry-path=/metricsRestart=always

[Install]
WantedBy=multi-user.target
```


2.3. Start Service and Check Targets

```sh
sudo systemctl enable postgres-exporter.service
sudo systemctl start postgres-exporter.service
```

Remove files(optional)
`rm -rf postgres_exporter-0.15.0.linux-amd64.tar.gz`


### Installing and Configuring Grafana

Creating Service Users:

`sudo useradd --no-create-home --shell /bin/false grafana`

Go to the release page to select preferred version https://grafana.com/grafana/download?edition=oss

```
wget https://dl.grafana.com/oss/release/grafana-11.4.0.linux-amd64.tar.gz

tar -zxvf grafana-11.4.0.linux-amd64.tar.gz
```

`sudo cp grafana-v11.4.0/bin/grafana /usr/local/bin/`

`sudo cp grafana-v11.4.0/bin/grafana-cli /usr/local/bin/`

`sudo cp grafana-v11.4.0/bin/grafana-server /usr/local/bin/`

`sudo chown grafana:grafana /usr/local/bin/grafana-server`

#sudo mkdir /etc/grafana/

#sudo cp grafana-11.4.0.linux-amd64/

Define a systemd service for Grafana

`sudo nano /etc/systemd/system/grafana.service`

```yaml
[Unit]
Description=Grafana Server
Wants=network-online.target
After=prometheus.service

[Service]
User=grafana
Group=grafana
Type=simple
ExecStart=/usr/local/bin/grafana-server

[Install]
WantedBy=multi-user.target
```

Start and Access Grafana

```sh
sudo systemctl daemon-reload

sudo systemctl enable grafana.service 

sudo systemctl start grafana.service
```