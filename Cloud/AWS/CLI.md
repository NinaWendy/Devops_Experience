Installation

MAC

Install the AWS CLI version 1 using the bundled installer with sudo 

curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws ...... sudo /usr/local/bin/python3.13.2 awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

aws --version


curl "https://s3.amazonaws.com/aws-cli/awscli-bundle-1.32.0.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws


Install using PIP

curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
pip3 install awscli --upgrade --user
aws --version


which python
ls -al /usr/local/bin/python3


ln -s -f /usr/local/bin/python3 /usr/local/bin/python

LINUX

Python
apt-get install python3 python3-dev




INSTALL TERRAFORM

LINUX

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

terraform -help

touch ~/.bashrc

terraform -install-autocomplete



MAC

brew tap hashicorp/tap

brew install hashicorp/tap/terraform

terraform -help

touch ~/.zshrc

terraform -install-autocomplete