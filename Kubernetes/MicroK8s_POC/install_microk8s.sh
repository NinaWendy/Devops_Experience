#!/bin/bash

set -e

echo "1. Install MicroK8s on Linux"
sudo snap install microk8s --classic

echo "2. Join the group"
sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube

newgrp microk8s <<EOF

echo "3. Check the status while Kubernetes starts"
microk8s status --wait-ready

echo "4. Turn on services"
microk8s enable dashboard dns registry istio community

echo "5. Add alias for microk8s"
alias kubectl='microk8s kubectl'

echo "6. Check MicroK8s status"
microk8s status

EOF
