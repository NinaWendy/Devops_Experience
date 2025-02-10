- Create cluster

- Install helm

Note:
`Error: Kubernetes cluster unreachable`
workaround: mkdir /etc/microk8s
microk8s.config > /etc/microk8s/microk8s.conf
export KUBECONFIG=/etc/microk8s/microk8s.conf

Remember to change ownership of the folder and files

- Install Kubernetes operator

`helm repo add kfs https://kfsoftware.github.io/hlf-helm-charts --force-update`
`helm install hlf-operator --version=1.8.0 kfs/hlf-operator`


- Install krew

- Install kubectl plugin
`kubectl krew install hlf`

- Set Environment Variables
export PEER_IMAGE=hyperledger/fabric-peer
export PEER_VERSION=2.4.6

export ORDERER_IMAGE=hyperledger/fabric-orderer
export ORDERER_VERSION=2.4.6

- Install istio
Download the Istio CLI
Istio is configured using a command line tool called istioctl. Download it, and the Istio sample applications:

$ curl -L  https://istio.io/downloadIstio | sh -

$ cd istio-1.23.2

$ export PATH=$PWD/bin:$PATH


Check that you are able to run istioctl by printing the version of the command. At this point, Istio is not installed in your cluster, so you will see that there are no pods ready.

$ istioctl version

- Install Istio on to your cluster
istioctl install --set profile=ambient --skip-confirmation

- Install the Kubernetes Gateway API CRDs

kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml; }

-Doc

istioctl operator init

- Configurar DNS interno
`Refer to doc for code`

- Deploy a certificate authority

Note:
K8s cluster on the other hand, does not download also a default storage class.

In order to solve the problem:

Download rancher.io/local-path storage class:

kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

Check with kubectl get storageclass

Make this storage class (local-path) the default:

kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

NOTE:
Delete a ca
kubectl hlf ca delete --name org1-ca 
Install jq
`sudo snap install jq`

`kubectl hlf ca create --capacity=1Gi --name=org1-ca --enroll-id=enroll --enroll-pw=enrollpw --hosts=org1-ca.localho.st --istio-port=443`

sudo kubectl port-forward svc/org1-ca 443:7054

- Register user in ca of the peer org
`# register user in CA for peers`
`kubectl hlf ca register --name=org1-ca --user=peer --secret=peerpw --type=peer \`
` --enroll-id enroll --enroll-secret=enrollpw --mspid Org1MSP`

- Deploy a peer
`kubectl hlf peer create --statedb=couchdb --image=$PEER_IMAGE --version=$PEER_VERSION --enroll-id=peer --mspid=Org1MSP --enroll-pw=peerpw --capacity=5Gi --name=org1-peer0 --ca-name=org1-ca.default --hosts=peer0-org1.localho.st --istio-port=443`

`kubectl hlf peer create --statedb=couchdb --image=$PEER_IMAGE --version=$PEER_VERSION --enroll-id=peer --mspid=Org1MSP --enroll-pw=peerpw --capacity=5Gi --name=org1-peer1 --ca-name=org1-ca.default --hosts=peer1-org1.localho.st --istio-port=443`

- Create a certification authority(orderer)

- Register user orderer with password ordererpw

- Create orderer

- Register user orderer

- Deploy orderer
`sudo kubectl port-forward svc/ord-ca 443:7054` on a different terminal
`kubectl hlf ordnode create --image=$ORDERER_IMAGE --version=$ORDERER_VERSION --enroll-id=orderer --mspid=OrdererMSP --enroll-pw=ordererpw --capacity=2Gi --name=ord-node1 --ca-name=ord-ca.default --hosts=orderer0-ord.localho.st --istio-port=443`
`kubectl hlf ordnode delete --name=ord-node1`


-Prepare connection string to interact with orderer#

Get the connection string without users
kubectl hlf inspect --output ordservice.yaml -o OrdererMSP

Register a user in the certification authority for signature
Get the certificates using the user created above
Attach the user to the connection string


- Create channel#

To create the channel we need to first create the wallet secret, which will contain the identities used by the operator to manage the channel

Register and enrolling OrdererMSP identity

Register and enrolling Org1MSP identity

Note: Remember to change port forwarding between ordererca and org ca when running the above commands

- Create the secret#

- Create main channel#

- Join peer to the channel#

- Install a chaincode#

Prepare connection string for a peer#
To prepare the connection string, we have to:

Get connection string without users for organization Org1MSP and OrdererMSP

Register a user in the certification authority for signing (register)

Obtain the certificates using the previously created user (enroll)

Attach the user to the connection string

- Create metadata file#

- Prepare connection file#