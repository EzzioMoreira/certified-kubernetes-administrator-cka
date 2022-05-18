# Use kubectl drain to remove a node from service
You can use kubectl drain to safely evict all of your pods from a node before you perform maintenance on the node (e.g. kernel upgrade, hardware maintenance, etc.). Safe evictions allow the pod's containers to [gracefully terminate](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination) and will respect the [PodDisruptionBudgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) you have specified.

## Documentation
- [Draining a Node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)

### Create pod and deployment
Begin by creating some objects. We will examine how these objects are affected by the drain process.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: metal-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
  restartPolicy: OnFailure
```

```shell
kubectl apply -f pod.yml
```

Create a deployment with four replicas.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: metal-deployment
  labels:
    app: metal-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: metal-deployment
  template:
    metadata:
      labels:
        app: metal-deployment
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
```

```shell
kubectl apply -f deployment.yml
```

Get a list of pods. You should see the pods you just created. Take node of which node these pods are running on.

```shell
kubectl get pods -o wide
```

Drain the node which `metal-pod` pod is running.

```shell
kubectl drain <node name> --ignore-daemonsets --force
```

Check your list of pods again. You should see the deployment replica pods being moved to the remaining node. The regular pod will be deleted.

```shell
kubectl get pods -o wide
```

Check your list of nodes. The nodes has a taint: `SchedulingDisabled`.

```shell
kubectl get nodes        
NAME       STATUS                     ROLES                  AGE    VERSION
server01   Ready                      control-plane,master   116d   v1.23.2
server02   Ready,SchedulingDisabled   <none>                 116d   v1.23.2
server03   Ready                      <none>                 116d   v1.23.2
```

Uncordon the node to allow new pods to be scheduled there again.

```shell
kubectl uncordon <node name>
```

Delete the deployment created for this lesson.

```shell
kubectl delete deployment my-deployment
```
