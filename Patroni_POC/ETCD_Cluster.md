# ETCD Cluster Setup

Download installation tar for your architecture from [etcd releases](https://github.com/etcd-io/etcd/releases/)

```sh
wget https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-amd64.tar.gz
```

Once downloaded, unzip and copy binaries to your `/usr/bin`

```sh
tar -xvf etcd-v3.5.0-linux-amd64.tar.gz
cd etcd-v3.5.0-linux-amd64/
sudo cp etcd etcdctl etcdutl /usr/bin/
```

Check version

```sh
etcd --version
```

## Configure and Run 3 Node ETCD Cluster

Create etcd user and group for etcd binaries to run

```sh
groupadd --system etcd
useradd -s /bin/bash --system -g etcd etcd
```

Create two directories (data and configuration)

```sh
sudo mkdir -p /var/lib/etcd/
sudo mkdir /etc/etcd
sudo chown -R etcd:etcd /var/lib/etcd/ /etc/etcd
```

Login using etcd user and create `.bash_profile` file with the below content

```sh
export ETCD_NAME=$(hostname -s)
export ETCD_HOST_IP=$(hostname -i)
```

Alternatively add the below content to `/etc/etcd/etcd.conf` 

```sh
ETCD_NAME=etcd1
ETCD_HOST_IP=X.X.X.X

```

Create Service etcd in `/etc/systemd/system/etcd.service`, repace IP addresses with your corresponding machine IPs

```ini
[Unit]
Description=etcd
After=syslog.target network.target

[Service]
Type=simple
User=etcd
Group=etcd
WorkingDirectory=/var/lib/etcd/
ExecStart=/usr/bin/etcd \
  --name ${HOST_NAME} \
  --data-dir=/var/lib/etcd \
  --initial-advertise-peer-urls ${HOST_IP}:2380 \
  --listen-peer-urls http://${HOST_IP}:2380,http://127.0.0.1:7001 \
  --listen-client-urls http://127.0.0.1:2379,http://${HOST_IP}:2379 \
  --advertise-client-urls http://${HOST_IP}:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster DB2=http://X.X.X.X:2380,DB3=http://X.X.X.X:2380,DB4=http://X.X.X.X:2380 \
  --initial-cluster-state new

[Install]
WantedBy=multi-user.target
```

Once the service is created, enable the service and start it on all three servers:

```sh
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
```

You can check the cluster working by issuing the following commands:

```sh
etcdctl member list --write-out=table
```

Check Leader:

```sh
etcdctl --write-out=table --endpoints="127.0.0.1:2379" endpoint status
```

**NOTE:**

```sh
--initial-cluster-token etcd-cluster-0
```

This must be the same on all nodes.
