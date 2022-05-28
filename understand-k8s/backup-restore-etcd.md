# Backing Up and Restoring Etcd Cluster Data
All Kubernetes objects are stored on etcd. Periodically backing up the etcd cluster data is important to recover Kubernetes clusters under disaster scenarios, such as losing all control plane nodes. The snapshot file contains all the Kubernetes states and critical information. In order to keep the sensitive Kubernetes data safe, encrypt the snapshot files.

Backing up an etcd cluster can be accomplished in two ways: etcd built-in snapshot and volume snapshot.

## Documentation

- [Backing up an etcd cluster](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster)

### Backup Etcd
Back up etcd using etcdctl and the provided etcd certificates

```shel
sudo ETCDCTL_API=3 etcdctl snapshot save ~/etcd_backup.db \
--endpoints=https://PRIVATE_IP:2379 \
--cacert=/etc/etcd/etcd-ca.crt \
--cert=/etc/etcd/server.crt \
--key=/etc/etcd/server.key
```

Verify the snapshot.

```shel
sudo ETCDCTL_API=3 etcdctl --write-out=table snapshot status ~/etcd_backup.db
```

Stopped etcd and removing all existing ectd data. 

```shel
sudo systemctl stop etcd
sudo rm -rf /var/lib/etcd
```

Restore the etcd data from the backup. This command spins up a temporary etcd cluster, saving the data from the backup file to a new data directory (in the same location where the previous data directory was).

```shel
sudo ETCDCTL_API=3 etcdctl --data-dir /var/lib/etcd snapshot restore ~/etcd_backup.db
```

Set ownership on the new data directory.

```shel
sudo chown -R etcd:etcd /var/lib/etcd
```

Start etcd.

```shel
sudo systemctl start etcd
```

Verify that the restored data is present by looking up the value for the key cluster.name.

```shel
sudo ETCDCTL_API=3 etcdctl get cluster.name \
--endpoints=https://PRIVATE_IP:2379 \
--cacert=/etc/etcd/etcd-ca.crt \
--cert=/etc/etcd/server.crt \
--key=/etc/etcd/server.key
```
