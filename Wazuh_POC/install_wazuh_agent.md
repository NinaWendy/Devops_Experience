wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.10.1-1_amd64.deb && sudo WAZUH_MANAGER='x.x.x.x' WAZUH_REGISTRATION_PASSWORD=$'Password123' WAZUH_AGENT_GROUP='default' dpkg -i ./wazuh-agent_4.10.1-1_amd64.deb

sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
