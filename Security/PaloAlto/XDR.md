# Cortex XDR Linux Agent Installation

## Configuration
Before installing the agent, please copy `cortex.conf` into `/etc/panw/` directory.


```bash

ssh user@host_ip

sshuttle -r ubuntu@destination_ip -e "ssh -J ubuntu@jumpbox_ip" 0/0

scp -r agent_deb/ ubuntu@host_ip:~

sudo mkdir -p /etc/panw

sudo cp cortex.conf /etc/panw/

sudo dpkg -i cortex-8.7.0.131113.deb

```

## Installation
For complete installation instructions including setting up Cortex XDR GPG public key, please visit the [installation page](https://docs.paloaltonetworks.com/cortex/cortex-xdr/cortex-xdr-pro-admin/get-started-with-cortex-xdr-pro/plan-your-cortex-xdr-deployment.html).

