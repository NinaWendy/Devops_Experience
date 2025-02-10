
# Hyperledger Fabric POC Setup Guide

## Prerequisites

1. Install `microk8s`
2. Join nodes to the cluster
3. Install `helm`
4. Install `krew`

## Setup Instructions

### 1. Install Hyperledger Fabric Operator and Plugin

- Use Helm to install the HLF operator.
- Use Krew to install the HLF plugin.
- Get the storage class where persistent volumes will be provisioned for CAs and peers.

### 2. Create Namespaces

- `default` (for HLF operator)
- `fabric` (for certificate authority, orderer, organizations-peers, chaincode)

### 3. Deployment Steps

1. Deploy the operator.
2. Create CAs.
3. Register peers.
4. Create peers.

### 4. Create Admin Entity (Organization) for Transactions

1. Register Identity:
	- Get the certificate of identity.
	- Obtain the signing certificate from CA.
	- Obtain the TLS certificate from TLSCA.
2. Enroll Identity:
	- Enroll identity types: peer, admin, client, orderer.
3. Register Orderer.
4. Create Orderer Service.
5. Create Orderer Admin Identity:
	- Get the signing certificate and enroll the user.
	- Obtain the TLS certificate.
6. Grab Connection Profile:
	- Add the admin user to the connection profile.
7. Create Channel:
	- Make the orderer join the channel using the TLS identity, not the normal signing certificate.
	- Make peers join the channel, specifying network config, user, and target peer.
	- Add the peer as an anchor peer on the channel.

### 5. Chaincode Setup

1. Define chaincode on the peer.

## Tips

- Update `.bashrc`:
  ```bash
  source .bashrc
  ```
- Alias `microk8s kubectl`:
  ```bash
  sudo snap alias microk8s.kubectl kubectl
  ```

