# ANSIBLE

## Install Python

```sh
sudo apt install python3
```

Check Python version:

```sh
python3 -m pip -V
```

Install `python3-pip`:

```sh
sudo apt install -y python3-pip
```

## Install Ansible on Ubuntu

Update and install required packages:

```sh
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

### Install using pip

```sh
python3 -m pip install --user ansible
```

Verify Ansible installation:

```sh
ansible --version
```

### Upgrade Ansible

```sh
python3 -m pip install --upgrade --user ansible
```

## Setup

Add Ansible command shell completion:

```sh
python3 -m pip install --user argcomplete
activate-global-python-argcomplete --user
```

Create and navigate to the Ansible directory:

```sh
mkdir ansible && cd ansible
```

## Create Inventory

Add the public key of the Ansible host to the authorized keys file of each host.

Create a file named `inventory.yaml` and add a new `[myhosts]` group to the file:

```yaml
myhosts:
  hosts:
    my_host_01:
      ansible_host: 192.0.2.50
    my_host_02:
      ansible_host: 192.0.2.51
    my_host_03:
      ansible_host: 192.0.2.52
```

Verify your inventory:

```sh
ansible-inventory -i inventory.yaml --list
```

Ping the `myhosts` group in your inventory:

```sh
ansible -u ubuntu myhosts -m ping -i inventory.yaml
```

### Notes

**Group hosts according to the topology:**

- By role: db, web
- By location: datacenter, region, floor, building
- By stage: development, test, staging, production

**Configure the Ansible Host for Passwordless SSH:**

Set up passwordless SSH authentication to streamline Ansible's operations.

Generate an SSH Key Pair on the Ansible Host:

```sh
ssh-keygen -t rsa -b 2048
```

Copy the SSH Key to Managed Servers:

```sh
ssh-copy-id user@managed_server_ip
```

Alternatively, copy the public key to the server:

```sh
cat ~/.ssh/id_rsa.pub | ssh user@managed_server_ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

**Note:** Make sure in the inventory file it's `ansible_host`.

Use nano as the default editor for creating a vault:

```sh
nano .bashrc
```

Add this line below:

```sh
export EDITOR=nano
```

Reload the bash configuration:

```sh
. ~/.bashrc
```
