#!/bin/bash

# Function to print steps
print_step() {
    echo "=============================="
    echo "$1"
    echo "=============================="
}

# Step 1: Install Docker
print_step "Installing Docker"
./install_docker.sh

# Step 2: Install MicroK8s
print_step "Installing MicroK8s"
./install_micok8s.sh

# Step 3: Install PostgreSQL
print_step "Installing PostgreSQL"
./install_postgres.sh

# Step 4: Get DB username and password credentials
print_step "Getting DB username and password credentials"
# Add your code to get DB credentials here
```
sudo -u postgres psql

CREATE DATABASE todo;

CREATE USER postgres WITH ENCRYPTED PASSWORD 'password';

GRANT ALL PRIVILEGES ON DATABASE todo TO postgres;

```
# Step 5: Connect application to DB
print_step "Connecting application to DB"
# Update dev.exs
```
  config :todo_trek, TodoTrek.Repo,
  username: "postgres",
  password: "password",
  # specify the ip address of your machine
  hostname: "x.x.x.x",
  database: "todo",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```
# Step 6: Update pg_hba.conf file
print_step "Updating pg_hba.conf file"
# Add your code to update pg_hba.conf here
```
sudo nano /etc/postgresql/12/main/pg_hba.conf
```
# Add the following line to the file
```
host    all             all             x.x.x.x/32            md5
```
# Restart PostgreSQL
```
sudo systemctl restart postgresql
```

# Step 7: Create Dockerfile
print_step "Creating Dockerfile"
# Add DB connection URL
# Add database URL to Dockerfile
```
ENV DATABASE_URL=postgresql://postgres:password@x.x.x.x:5432/todo
```
# Step 8: Create Docker image
print_step "Creating Docker image"
sudo docker build -t todotrek:v1 .

# Step 9: Create Docker container
print_step "Creating Docker container"
sudo docker run --name todotrek_container -d -p 4000:4000 todotrek:v1

# Step 10: Create image in MicroK8s registry
print_step "Creating image in MicroK8s registry"
sudo docker build . -t localhost:32000/todotrek:v1
sudo docker push localhost:32000/todotrek:v1

# Step 11: List images in MicroK8s registry
print_step "Listing images in MicroK8s registry"
curl http://192.168.84.39:32000/v2/_catalog

# Step 12: Create Deployment
print_step "Creating Deployment"
kubectl apply -f deployment.yaml

# Step 13: Enable metalLB
print_step "Enabling metalLB"
microk8s enable metallb
# Specify IP range
echo "Specify IP range: 192.168.84.39-192.168.84.45"

# Step 14: Create Service
print_step "Creating Service"
kubectl apply -f service.yaml

echo "All steps completed successfully!"
