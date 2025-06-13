# SENTRY

## Requirements

- Docker 19.03.6
- Docker Compose 2.32.2
- 4 CPU Cores
- 16 GB RAM
- 20 GB Free Disk Space

## Installation


Docker

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

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

docker --version


```sh
VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/getsentry/self-hosted/releases/latest)

VERSION=${VERSION##*/}

git clone https://github.com/getsentry/self-hosted.git

https://github.com/getsentry/self-hosted/archive/refs/tags/25.4.0.zip

cd self-hosted

git checkout ${VERSION}

CSRF_TRUSTED_ORIGINS = ["http://172.18.8.190:9000"]

add this to `sudo nano sentry/sentry.conf.py`

./install.sh
 `use sudo if fails`
# After installation, run the following to start Sentry:
docker compose up --wait
```

Go to `http://127.0.0.1:9000 `

## Installing Behind a Proxy

`nano /etc/systemd/system/docker.service.d/http-proxy.conf`

```yaml
[Service]
Environment="HTTP_PROXY=http://proxy:3128"
Environment="HTTPS_PROXY=http://proxy:3128"
Environment="NO_PROXY=127.0.0.0/8"
```

`systemctl daemon-reload`

`systemctl restart docker.service`


## Commands
```sh
apt-get install curl git build-essential apt-transport-https ca-certificates software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubu... | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list  /dev/null

apt install docker docker-compose -y

systemctl status docker

docker --version

docker-compose --version

git clone https://github.com/getsentry/onpremise

cd onpremise

bash install.sh

docker images

docker-compose up -d

docker-compose ps
```


## APP SDK

### Elixir

Getting Started is Simple
Edit your mix.exs file to add it as a dependency and add the :sentry package to your applications:

Click to Copy
defp deps do
[
  # ...
  {:sentry, "~> 8.0"},
  {:jason, "~> 1.1"},
  # if you are using plug_cowboy
  {:plug_cowboy, "~> 2.3"}
]
end
Setup the application production environment in your config/prod.exs

Click to Copy
config :sentry,
dsn: "https://<key>@sentry.io/<project>",
environment_name: :prod,
enable_source_code_context: true,
root_source_code_path: File.cwd!(),
tags: %{
  env: "production"
},
included_environments: [:prod]