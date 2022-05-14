# Building a Kubernetes Cluster

Use this step by step for building you cluster.

## Documentation
- [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

Before continuing with this lesson make sure that infrastructure exists 
> [Creating infrastructure](./lab-ec2/README.md)

### Doors we should be concerned about

**MASTER**

Protocol|Direction|Port Range|Purpose|Used By
--------|---------|----------|-------|-------
TCP|Inbound|6443*|Kubernetes API server|All
TCP|Inbound|2379-2380|etcd server client API|kube-apiserver, etcd
TCP|Inbound|10250|Kubelet API|Self, Control plane
TCP|Inbound|10251|kube-scheduler|Self
TCP|Inbound|10252|kube-controller-manager|Self

**WORKERS**

Protocol|Direction|Port Range|Purpose|Used By
--------|---------|----------|-------|-------
TCP|Inbound|10250|Kubelet API|Self, Control plane
TCP|Inbound|30000-32767|NodePort|Services All

### Configuration hostname
On the `srv-01` define the hostname with the following command:
```shell
sudo hostnamectl set-hostname k8s-master
```
> this host will be our control-plane

On the `srv-02, srv-03` define the hostname with the following command:
```shell
sudo hostnamectl set-hostname k8s-node"<01,02>"
```
> these hosts will be our nodes

On all nodes, set up the hosts file to enable all the nodes to reach each other using these hostnames:
```shell
sudo vi /etc/hosts
```
On all nodes, add the following at the end of the file. You will need to supply the actual private IP address for each node.
```shell
PRIVATE-IP k8s-master
PRIVATE-IP k8s-node01
PRIVATE-IP k8s-node02
```
### Configure containerd
On all nodes, set up containerd. You will need to load some kernel modules and modify some system settings as part of this process.

```shell
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

```shell
sudo modprobe overlay
sudo modprobe br_netfilter
```

```shell
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
```shell
sudo sysctl --system
```

Install and configure containerd.

```shell
sudo apt-get update && sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
```

On all nodes, disable swap. 

```shell
sudo swapoff -a
```

### Install kubeadm
On all nodes, install kubeadm, kubelet, and kubectl.

```shell
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```

```shell
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

```shell
sudo apt-get update
sudo apt-get install -y kubelet=1.23.0-00 kubeadm=1.23.0-00 kubectl=1.23.0-00
sudo apt-mark hold kubelet kubeadm kubectl
```

### Inicialize the cluster
On the node `k8s-master`, initialize the cluster and set up kubectl access.

```shell
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Verify the cluster is working.

```shell
kubectl get nodes
```

### Install network add-on
You must deploy a Container Network Interface (CNI) based Pod network add-on so that your Pods can communicate with each other.

Install the Calico network add-on.

```shell
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

### Join nodes worker cluster
Get the join command (this command is also printed during kubeadm init . Feel free to simply copy it from there)

```shell
kubeadm token create --print-join-command
```

Copy the join command from the control plane node. Run it on each worker node as root (i.e. with sudo )

```shell
sudo kubeadm join IP-k8s-master:6443 --token XXXXXXXXXXXXXXXXX \ 
    --discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

On the control plane node, verify all nodes in your cluster are ready. Note that it may take a few moments for all of the nodes to
enter the READY state.

```shell
kubectl get nodes
```
The output will be:

```shell
NAME         STATUS   ROLES                  AGE     VERSION
k8s-master   Ready    control-plane,master   4m11s   v1.23.0
k8s-node01   Ready    <none>                 2m11s   v1.23.0
k8s-node02   Ready    <none>                 2m11s   v1.23.0
```