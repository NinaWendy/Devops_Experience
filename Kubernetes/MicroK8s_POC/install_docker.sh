#!/bin/bash

set -e

echo "1. Operating System"
uname -a 

echo "2. OS version"
lsb_release -a

echo "3. Updating existing list of packages"
sudo apt update

echo "4. Installing prerequisite packages for apt to use HTTPS"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "5. Adding the GPG key for the official Docker repository to your system"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "6. Adding the Docker repository to APT sources"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

echo "7. Installing Docker"
sudo apt install -y docker-ce

echo "8. Checking if Docker is running"
sudo systemctl status docker

echo "9. Allowing Docker to run without sudo (optional)"
# Uncomment the following line to add the current user to the Docker group
# sudo usermod -aG docker ${USER}
