# Upgrading kubeadm clusters
This page explains how to upgrade a Kubernetes cluster created with kubeadm from version 1.23.x to version 1.24.x, and from version 1.24.x to 1.24.y (where y > x). Skipping MINOR versions when upgrading is unsupported. For more details, please visit Version [Skew Policy](https://kubernetes.io/releases/version-skew-policy/).

## Documentation

- [Upgrading K8s with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)

### Upgrade the control plane
First, we need drain the control plane. 

```shel
kubectl drain k8s-master --ignore-daemonsets
```
Upgrading kubeadm

```shel
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubeadm=1.22.2-00
kubeadm version
```

Plan the upgrande.

```shel
sudo kubeadm upgrade plan v1.22.2
```

Upgrade the control plane components. 

```shel
sudo kubeadm upgrade apply v1.22.2
```

Upgrande kubelet and bubectl on the control plane. 

```shel
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubelet=1.22.2-00 kubectl=1.22.2-00
```

Restart kubelet.

```shel
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

Uncordon the control plane. 

```shel
kubectl uncordon k8s-control
```

Verify that the control plane is working. 

```shel
kubectl get nodes
```

### Upgrade the workers

Drain the worker node. 

```shel
kubectl drain k8s-worker1 --ignore-daemonsets --force
```

Upgrade the kubeadm on the worker. 

```shel
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubeadm=1.22.2-00
```

Upgrade kubelet and kubectl on the worker node. 

```shel
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubelet=1.22.2-00 kubectl=1.22.2-00
```

Restart kubelet.

```shel
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

Uncordon the worker node. 

```shel
kubectl uncordon k8s-worker1
```

Verify that the worker is working. 

```shel
kubectl get nodes -o wide
```

> Repeat the upgrade process for another workers node.
