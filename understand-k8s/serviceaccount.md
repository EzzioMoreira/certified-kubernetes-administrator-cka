# Configure Service Accounts for Pods
A service account provides an identity for processes that run in a Pod.

When you (a human) access the cluster (for example, using `kubectl`), you are authenticated by the apiserver as a particular User Account (currently this is usually `admin`, unless your cluster administrator has customized your cluster). Processes in containers inside pods can also contact the apiserver. When they do, they are authenticated as a particular Service Account (for example, `default`).

## Documentation

- [ServiceAccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- [Using RBAC ServiceAccount](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

### Use the Default Service Account to access the API server.
When you create a pod, if you do not specify a service account, it is automatically assigned the default service account in the same namespace.

Exemplo: Create a credentials for a service account.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: build-robot
automountServiceAccountToken: false
```

Exemplo: Configure a credentials for a pod. 

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: build-robot
  automountServiceAccountToken: false
```

### Attach a Role to the ServiceAccount with a RoleBinding.
A RoleBinding may reference any Role in the same namespace. Alternatively, a RoleBinding can reference a ClusterRole and bind that ClusterRole to the namespace of the RoleBinding. If you want to bind a ClusterRole to all the namespaces in your cluster, you use a ClusterRoleBinding.

> For more link access: [RBAC](./rbac-role-based-access-control.md)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: sa-pod-reader
  namespace: default
subjects:
- kind: ServiceAccount
  name: build-robot
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```