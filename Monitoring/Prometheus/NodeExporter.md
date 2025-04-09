wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz &&  \

tar xvf node_exporter-1.8.2.linux-amd64.tar.gz &&  \
cd node_exporter-1.8.2.linux-amd64 && \
sudo cp node_exporter /usr/local/bin && \
cd .. && \
rm -rf ./node_exporter-1.8.2.linux-amd64 && \
sudo useradd --no-create-home --shell /bin/false node_exporter &&  \
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter &&  \

sudo cat << EOF > /tmp/node_exporter.service 

[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --collector.systemd --collector.processes

[Install]
WantedBy=multi-user.target
EOF

sudo cp /tmp/node_exporter.service /etc/systemd/system/
echo "Reloading daemon and enabling service"
sudo systemctl daemon-reload && \
sudo systemctl enable node_exporter.service && \
sudo systemctl start node_exporter.service 