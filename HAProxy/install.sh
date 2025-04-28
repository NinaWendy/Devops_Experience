#! /bin/bash

# HAProxy installation script

sudo apt-get install --no-install-recommends software-properties-common \
sudo add-apt-repository ppa:vbernat/haproxy-2.8 \
sudo apt-get install haproxy=2.8.\*