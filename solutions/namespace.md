## Solutions 
1. Create the "staging" Namespace.

```shell
kubectl create namespace staging
```

2. List all of the current namespaces in the cluster. Save this list to the file `/tmp/namespaces.log`.

```shell
kubectl get namespace > /tmp/namespaces.log
```

3. Create a namespace whit name "production" and save it to the file `/tmp/production.yaml`.

```shell
kubectl create namespace production --dry-run=client -o yaml > /tmp/production.yaml
```