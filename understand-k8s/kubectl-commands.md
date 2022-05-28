# Command line tool (kubectl)
kubectl is a command line tool that allows you to interact with Kubernetes. kubectl uses the kubernetes API to communicate with the cluster and carry out your commands.

> You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs.

## Documentation

- [Kubectl command line](https://kubernetes.io/docs/reference/kubectl/)

### Create a deployment
Create a deployment and apply this manifest in your cluster. `kubectl create -f deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-metal
  labels:
    app: app-metal
spec:
  replicas: 4
  selector:
    matchLabels:
      app: app-metal
  template:
    metadata:
      labels:
        app: app-metal
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
```

### kubectl api-resources
You must specify the type of resource to get. Use "kubectl api-resources" for a complete list of supported resources.

```shell
kubectl api-resources
```
The output is similar:

```shell
NAME                 SHORTNAMES   APIVERSION   NAMESPACED   KIND
bindings                          v1           true         Binding
componentstatuses    cs           v1           false        ComponentStatus
configmaps           cm           v1           true         ConfigMap
endpoints            ep           v1           true         Endpoints
events               ev           v1           true         Event
limitranges          limits       v1           true         LimitRange
namespaces           ns           v1           false        Namespace
nodes                no           v1           false        Node
```

### Kubectl get
Use `kubectl get` to list objects in the Kubernetes cluster. Prints a table of the most important information about the specified resources.

```shell
kubectl get <resources name>
```

- Set output format: `-o`
    - `kubectl get pods -o yaml`
    - `kubectl get pods -o wide`
    - `kubectl get pods -o json`
- Sort output using a JSON path expression. `--sort-by`
    - `kubectl get pods --sort-by=.status.containerStatuses[0].restartCount`
    - `kubectl get pods -o wide --sort-by .spec.nodeName`
- Filter results by label. `--selector`
    - `kubectl get pods -n kube-system --selector k8s-app=calico-node`

### Kubectl describe
You can get detailed information about Kubernetes objects using kubectl describe. 

```shell
kubectl describe <object type> <object name>
kubectl describe pod app-metal-xyz-2xmbq
kubectl describe deployment app-metal
```

### Kubectl create
Use kubectl create to create objects. Supply a YAML file with -f to create an object from a YAML descriptor stored in the file.

```shell
kubectl create -f <file name>
```

### Kubectl apply
kubectl apply is similar to kubectl create. However, if you use kubectl apply on an object that already exists, it will modify the existing object, if possible.

```shell
kubectl apply -f <file name>
```

### Kubectl delete
Use kubectl delete to delete objects from the cluster.

```shell
kubectl delete <object type> <object name>
```

### Kubectl exec
kubectl exec can be used to run commands inside containers. Keep in mind that, in order for a command to succeed, the necessary software must exist within the container to run it. For pods with multiple containers, specify the container name with -c.

```shell
kubectl exec <pod name> -c <container name> --<command>
kubectl exec app-metal-bfb8fb68-2xmbq -- hostname
```
