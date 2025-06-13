## Install tmux
sudo apt-get update && sudo apt-get install tmux

tmux new -s mysession

tmux a -t mysession

## Installation

sudo snap install microk8s --classic

sudo usermod -a -G microk8s ubuntu

sudo chown -f -R ubuntu ~/.kube

mkdir -p ~/.kube

chmod 0700 ~/.kube

microk8s status --wait-ready

microk8s enable dashboard dns registry istio community

alias kubectl='microk8s kubectl'

microk8s status

## Cluster Setup

On master(Repeat for each node added)
`microk8s add-node`

On worker nodes
`microk8s join...`

ERRORS

`sudo snap changes`

`sudo snap abort $ID`

`sudo snap refresh microk8s`
