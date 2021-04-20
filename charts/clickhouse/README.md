# Deploy DBKernel ClickHouse On kubernetes

## Introduction

DBKernel ClickHouse is an open-source, cloud-native, highly availability cluster solutions based on [ClickHouse](https://clickhouse.tech/).

This tutorial demonstrates how to deploy DBKernel ClickHouse on Kubernetes.

## Prerequisites

- You have created a Kubernetes Cluster.

## Procedure

### Step 1 : Add Helm Repository

Add and update helm repositor.

```shell
$ helm repo add dbkernel https://dbkernel.github.io/helm-charts/
$ helm repo update
```

### Step 2 :  Install to Kubernetes

> Zookeeper store ClickHouse's metadata. You can install Zookeeper and ClickHouse Cluster at the same time.

1. In default, the chart will create a ClickHouse Cluster with one shard and two replicas.

   ```shell
   helm install clickhouse dbkernel/clickhouse -n default
   ```

   **Expected output:**

   ```shell
   $ helm install clickhouse dbkernel/clickhouse -n default
   NAME: clickhouse
   LAST DEPLOYED: Mon Aug 23 08:19:59 2021
   NAMESPACE: default
   STATUS: deployed
   REVISION: 1
   TEST SUITE: None
   $  helm list
   NAME                	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART                     	APP VERSION
   clickhouse          	default  	1       	2021-08-23 08:19:59.233328928 +0000 UTC	deployed	clickhouse-0.1.0          	21.1
   ```

2. For more configurable options and variables, see [values.yaml](values.yaml).

### Step 3 :  Verification

#### Check the Pod
```shell
kubectl get all --selector app.kubernetes.io/instance=clickhouse
```

**Expected output:**

```shell
$ kubectl get all --selector app.kubernetes.io/instance=clickhouse
NAME                     READY   STATUS    RESTARTS   AGE
pod/clickhouse-s0-r0-0   1/1     Running   0          47s
pod/clickhouse-s0-r1-0   1/1     Running   0          47s

NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
service/clickhouse         ClusterIP   10.96.39.41    <none>        9000/TCP,8123/TCP   47s
service/clickhouse-s0-r0   ClusterIP   10.96.238.66   <none>        9000/TCP,8123/TCP   47s
service/clickhouse-s0-r1   ClusterIP   10.96.89.37    <none>        9000/TCP,8123/TCP   47s

NAME                                READY   AGE
statefulset.apps/clickhouse-s0-r0   1/1     47s
statefulset.apps/clickhouse-s0-r1   1/1     47s
```

#### Check the Status of Pod

You should wait a while，then check the output in `Reason` line. When the output persistently return `Started`, indicate that DBKernel ClickHouse is up and running.

```
kubectl describe pod <pod name>
```
**Expected output:**

```shell
$ kubectl describe pod clickhouse-s0-r0-0
...
Events:
  Type     Reason                  Age   From                     Message
  ----     ------                  ----  ----                     -------
  Normal   Scheduled               81s   default-scheduler        Successfully assigned default/clickhouse-s0-r0-0 to worker-p002
  Normal   SuccessfulAttachVolume  68s   attachdetach-controller  AttachVolume.Attach succeeded for volume "pvc-5e3d3508-3aff-4bfc-b0e9-a66f3da71c7e"
  Normal   Pulled                  63s   kubelet                  Container image "dbkernel/clickhouse-server:21.1.3.32" already present on machine
  Normal   Created                 63s   kubelet                  Created container clickhouse
  Normal   Started                 63s   kubelet                  Started container clickhouse
```

## Access DBKernel ClickHouse

### Use pod

You can directly connect to ClickHouse Pod with `kubectl`.

```
$ kubectl get pods | grep clickhouse
clickhouse-s0-r0-0   1/1     Running   0          8m50s
clickhouse-s0-r1-0   1/1     Running   0          8m50s

$ kubectl exec -it clickhouse-s0-r0-0 -- clickhouse client -u default --password=C1ickh0use --query='select hostName()'
clickhouse-s0-r0-0

```

### Use Service

The Service `spec.type` is `ClusterIP`, so you need to create a client to connect the service.

```bash
$ kubectl get service | grep clickhouse
clickhouse             ClusterIP   10.96.39.41     <none>        9000/TCP,8123/TCP   12m
clickhouse-s0-r0       ClusterIP   10.96.238.66    <none>        9000/TCP,8123/TCP   12m
clickhouse-s0-r1       ClusterIP   10.96.89.37     <none>        9000/TCP,8123/TCP   12m
zk-client-clickhouse   ClusterIP   10.96.244.243   <none>        2181/TCP            12m
zk-server-clickhouse   ClusterIP   None            <none>        2888/TCP,3888/TCP   12m

$ cat client.yaml
apiVersion: v1
kind: Pod
metadata:
  name: clickhouse-client
  labels:
    app: clickhouse-client
spec:
  containers:
    - name: clickhouse-client
      image: dbkernel/clickhouse-server:21.1.3.32
      imagePullPolicy: Always

$ kubectl apply -f client.yaml
pod/clickhouse-client created

$ kubectl exec -it clickhouse-client -- clickhouse client -u default --password=C1ickh0use -h 10.96.39.41 --query='select hostName()'
clickhouse-s0-r0-0
$ kubectl exec -it clickhouse-client -- clickhouse client -u default --password=C1ickh0use -h 10.96.39.41 --query='select hostName()'
clickhouse-s0-r1-0
```

## Persistence

You can configure a Pod to use a PersistentVolumeClaim(PVC) for storage.
In default, PVC mount on the `/var/lib/clickhouse` directory.

1. You should create a Pod that uses the above PVC for storage.

2. You should create a PVC that is automatically bound to a suitable PersistentVolume(PV).

> **Note**
> PVC can use different PV, so using the different PV show the different performance.
