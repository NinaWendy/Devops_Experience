
Installation
Portainer requires data persistence, and as a result needs at least one StorageClass available to use. Portainer will attempt to use the default StorageClass during deployment. If you do not have a StorageClass tagged as default the deployment will likely fail.

`kubectl get sc`

`kubectl patch storageclass <storage-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'`

`kubectl apply -n portainer -f https://downloads.portainer.io/ce-lts/portainer.yaml`

`https://localhost:30779/ or http://localhost:30777/`