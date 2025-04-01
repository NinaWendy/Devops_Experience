# Hyperledger Fabric POC Steps

## Install Helm

**Note:**
If you encounter the error `Error: Kubernetes cluster unreachable`, use the following workaround:
```sh
mkdir /etc/microk8s
microk8s.config > /etc/microk8s/microk8s.conf
export KUBECONFIG=/etc/microk8s/microk8s.conf
```
Remember to change the ownership of the folder and files.

## Install Kubernetes Operator

Add the Helm repository and install the HLF operator:
```sh
helm repo add kfs https://kfsoftware.github.io/hlf-helm-charts --force-update
helm install hlf-operator --version=1.8.0 kfs/hlf-operator
```

## Install Krew

Install the Krew plugin manager for kubectl:
```sh
kubectl krew install hlf
```

## Set Environment Variables

Set the following environment variables:
```sh
export PEER_IMAGE=hyperledger/fabric-peer
export PEER_VERSION=2.4.6
export ORDERER_IMAGE=hyperledger/fabric-orderer
export ORDERER_VERSION=2.4.6
```

## Install Istio

Download the Istio CLI and configure it:
```sh
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.23.2
export PATH=$PWD/bin:$PATH
```
Verify the installation:
```sh
istioctl version
```
Install Istio on your cluster:
```sh
istioctl install --set profile=ambient --skip-confirmation
```

## Install the Kubernetes Gateway API CRDs

Install the Gateway API CRDs:
```sh
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml; }
```

## Initialize Istio Operator

Initialize the Istio operator:
```sh
istioctl operator init
```

## Configure Internal DNS

Refer to the documentation for the code to configure internal DNS.

## Deploy a Certificate Authority

**Note:**
If the Kubernetes cluster does not download a default storage class, solve the problem by downloading the Rancher local-path storage class:
```sh
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
kubectl get storageclass
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

To delete a CA:
```sh
kubectl hlf ca delete --name org1-ca
```
Install `jq`:
```sh
sudo snap install jq
```
Create a CA:
```sh
kubectl hlf ca create --capacity=1Gi --name=org1-ca --enroll-id=enroll --enroll-pw=enrollpw --hosts=org1-ca.localho.st --istio-port=443
sudo kubectl port-forward svc/org1-ca 443:7054
```

## Register User in CA of the Peer Org

Register a user in the CA for peers:
```sh
kubectl hlf ca register --name=org1-ca --user=peer --secret=peerpw --type=peer \
  --enroll-id enroll --enroll-secret=enrollpw --mspid Org1MSP
```

## Deploy a Peer

Deploy peers:
```sh
kubectl hlf peer create --statedb=couchdb --image=$PEER_IMAGE --version=$PEER_VERSION --enroll-id=peer --mspid=Org1MSP --enroll-pw=peerpw --capacity=5Gi --name=org1-peer0 --ca-name=org1-ca.default --hosts=peer0-org1.localho.st --istio-port=443
kubectl hlf peer create --statedb=couchdb --image=$PEER_IMAGE --version=$PEER_VERSION --enroll-id=peer --mspid=Org1MSP --enroll-pw=peerpw --capacity=5Gi --name=org1-peer1 --ca-name=org1-ca.default --hosts=peer1-org1.localho.st --istio-port=443
```

## Create a Certification Authority (Orderer)

Register the user `orderer` with password `ordererpw`.

## Create Orderer

Register the user `orderer`.

## Deploy Orderer

Deploy the orderer:
```sh
sudo kubectl port-forward svc/ord-ca 443:7054
kubectl hlf ordnode create --image=$ORDERER_IMAGE --version=$ORDERER_VERSION --enroll-id=orderer --mspid=OrdererMSP --enroll-pw=ordererpw --capacity=2Gi --name=ord-node1 --ca-name=ord-ca.default --hosts=orderer0-ord.localho.st --istio-port=443
kubectl hlf ordnode delete --name=ord-node1
```

## Prepare Connection String to Interact with Orderer

Get the connection string without users:
```sh
kubectl hlf inspect --output ordservice.yaml -o OrdererMSP
```
Register a user in the certification authority for signature. Get the certificates using the user created above and attach the user to the connection string.

## Create Channel

To create the channel, first create the wallet secret containing the identities used by the operator to manage the channel.

Register and enroll OrdererMSP and Org1MSP identities.

**Note:** Remember to change port forwarding between orderer CA and org CA when running the above commands.

## Create the Secret

## Create Main Channel

## Join Peer to the Channel

## Install a Chaincode

## Prepare Connection String for a Peer

To prepare the connection string:
1. Get the connection string without users for Org1MSP and OrdererMSP.
2. Register a user in the certification authority for signing (register).
3. Obtain the certificates using the previously created user (enroll).
4. Attach the user to the connection string.

## Create Metadata File

## Prepare Connection File
