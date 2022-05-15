# Using Namespaces in K8s
In Kubernetes, namespaces provides a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces. Namespace-based scoping is applicable only for namespaced objects (e.g. Deployments, Services, etc) and not for cluster-wide objects (e.g. StorageClass, Nodes, PersistentVolumes, etc).

## Documentation

- [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

### Viewing namespaces
Kubernetes starts with four initial namespaces:
- `default` The default namespace for objects with no other namespace.
- `kube-system` The namespace for objects created by the Kubernetes system
- `kube-public` This namespace is created automatically and is readable by all users (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.
- `kube-node-lease` This namespace holds [Lease](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/lease-v1/) objects associated with each node. Node leases allow the kubelet to send [heartbeats](https://kubernetes.io/docs/concepts/architecture/nodes/#heartbeats) so that the control plane can detect node failure.

### List namespaces in the cluster

```shel
kubectl get namespaces
```

Specify a namespace when listing other objects such as pods, deployment, secrets, etc.

```shell
kubectl get pods -n kube-system
```

Create a namespace.

```shell
kubectl create namespace my-namespace
```
Create a manifest for namespace using the following command.

```shell
kubectl create namespace my-namespace --dry-run=client -o yaml
```

The output of the command above. 

```yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: my-namespace
spec: {}
status: {}
```
### Namespaces and DNS 

When you create a [Service](https://kubernetes.io/docs/concepts/services-networking/service/), it creates a corresponding [DNS entry](https://kubernetes.io/docs/concepts/services-networking/ 
ns-pod-service/). This entry is of the form `<service-name>.<namespace-name>.svc.cluster.local`, 
which means that if a container only uses `<service-name>`, it will resolve to the service which 
is local to a namespace. This is useful for using the same configuration across multiple 
namespaces such as Development, Staging and Production. If you want to reach across namespaces, 
you need to use the fully qualified domain name (FQDN).
