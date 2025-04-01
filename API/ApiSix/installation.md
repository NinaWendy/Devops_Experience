Install etcd

```sh
ETCD_VERSION='3.5.4'
wget https://github.com/etcd-io/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz
tar -xvf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz && \
  cd etcd-v${ETCD_VERSION}-linux-amd64 && \
  sudo cp -a etcd etcdctl /usr/bin/
nohup etcd >/tmp/etcd.log 2>&1 &

```

Create service file for etcd

`sudo nano /etc/systemd/system/etcd.service`

``yaml
[Unit]
Description=etcd key-value store
Documentation=https://github.com/coreos/etcd
After=network.target

[Service]
ExecStart=/usr/bin/etcd --listen-client-urls=http://0.0.0.0:2379 --advertise-client-urls=http://0.0.0.0:2379
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target

````


## Install apisix

`wget -O - http://repos.apiseven.com/pubkey.gpg | sudo apt-key add -`

`echo "deb http://repos.apiseven.com/packages/debian bullseye main" | sudo tee /etc/apt/sources.list.d/apisix.list`

`sudo apt update`

`sudo apt install -y apisix=3.8.0-0`

`sudo apisix init`

`sudo nano /usr/local/apisix/conf/config.yaml `

```yaml
apisix:
  node_listen: 9080

deployment:
  role: traditional
  role_traditional:
    config_provider: etcd
  admin:
    admin_key:
      - name: admin
        key: xxxxxxx  # using fixed API token has security risk, please update it when you deploy to production environment
        role: admin

````

`curl http://127.0.0.1:9180/apisix/admin/routes?api_key=xxxxxxx -i`

Replace with key

`systemctl start apisix`

`systemctl stop apisix`

## Dashboard

Prerequisite

1. Install GO

`wget https://go.dev/dl/go1.23.6.linux-amd64.tar.gz`

`tar -C /usr/local -xzf go1.23.6.linux-amd64.tar.gz`

`export PATH=$PATH:/usr/local/go/bin`

`go version`

`echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile`

`source ~/.profile`

`echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc`

`source ~/.bashrc`

2. Install Nodejs

```yaml
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.13.1".
nvm current # Should print "v22.13.1".

# Verify npm version:
npm -v # Should print "10.9.2".
```

3. Install Yarn

`corepack enable`

`yarn init -2`

`yarn set version stable`

`yarn install`

4. Download Dashboard

`git clone -b release/3.0 https://github.com/apache/apisix-dashboard.git && cd apisix-dashboard1

Build

`cd apisix-dashboard`

`make build`

Launch dashboard

`cd ./output`

`./manager-api`

Create service

```sh
mkdir -p /usr/local/apisix-dashboard
cp -rf ./output/* /usr/local/apisix-dashboard
```

create service unit

```yaml

# copy service unit
cp ./api/service/apisix-dashboard.service /usr/lib/systemd/system/apisix-dashboard.service
systemctl daemon-reload

# or: If you need to modify the service unit, you can use the following command
echo "[Unit]
Description=apisix-dashboard
Conflicts=apisix-dashboard.service
After=network-online.target

[Service]
WorkingDirectory=/usr/local/apisix-dashboard
ExecStart=/usr/local/apisix-dashboard/manager-api -c /usr/local/apisix-dashboard/conf/conf.yaml" > /usr/lib/systemd/system/apisix-dashboard.service
```

Manage service

```sh
# start apisix-dashboard
systemctl start apisix-dashboard

# stop apisix-dashboard
systemctl stop apisix-dashboard

# check apisix-dashboard status
systemctl status apisix-dashboard
```

Docker installation

Install docker

```sh
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Clone apisix-dashboard repo

Build docker file
`$ docker build -t apisix-dashboard:v1 . `

# /path/to/conf.yaml Requires an absolute path pointing to the configuration file mentioned above.

$ docker run -d -p 9000:9000 -v /home/ubuntu/apisix-dashboard/api/conf/conf.yaml:/usr/local/apisix-dashboard/conf/conf.yaml --name apisix-dashboard apisix-dashboard:$tag

`docker ps -a`
