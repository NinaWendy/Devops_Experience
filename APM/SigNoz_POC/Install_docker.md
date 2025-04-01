Warning

Before you install Docker, make sure you consider the following security implications and firewall incompatibilities.

If you use ufw or firewalld to manage firewall settings, be aware that when you expose container ports using Docker, these ports bypass your firewall rules. For more information, refer to Docker and ufw.
Docker is only compatible with iptables-nft and iptables-legacy. Firewall rules created with nft are not supported on a system with Docker installed. Make sure that any firewall rulesets you use are created with iptables or ip6tables, and that you add them to the DOCKER-USER chain, see Packet filtering and firewalls.

Install using the apt repository

1. Set up Docker's apt repository.

2. Install the Docker packages.

3. Verify that the installation