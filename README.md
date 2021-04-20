![](https://dbkernel-1306518848.cos.ap-beijing.myqcloud.com/logos/logo-dbkernel-green.svg)


[![License](https://img.shields.io/badge/license-Apache-green.svg)](./LICENSE)
[![](https://github.com/dbkernel/helm-charts/workflows/helm-charts%2Frelease/badge.svg?branch=master)](https://github.com/dbkernel/helm-charts/actions)

# 1. 如何构建helm repo？

>**前提：**
>1. 已开启github pages，且选定路径为`/docs`。
>2. `docs`目录下创建`index.html`文件，内容可参考本项目下的`docs/index.html`。

## 1.1. 方法一：脚本自动构建

1. 执行`build.sh`即可自动构建出对应的tgz文件。
2. 将`tgz`文件等push到 github。

## 1.2. 方法二：手动构建

以`postgresql-ha`为例说明：
1. 打包：
```bash
helm package charts/postgresql-ha
```
2. 将`tgz`文件放到`./docs`：
```bash
mv postgresql-ha-x.x.x.tgz to ./docs
```
3. 构建`helm repo`：
```bash
helm repo index --url https://dbkernel.github.io/helm-charts/ ./docs
```
4. 拷贝`operator-install`文件到`./docs`目录，便于通过wget下载：
```bash
cp charts/clickhouse-operator-install.yaml ./docs
```
5. 将`/docs`推送到 github。


# 2. 如何安装到Kubernetes

## 2.1. 安装 helm chart

以`postgresql-ha`为例说明：

```bash
helm repo add dbkernel https://dbkernel.github.io/helm-charts/
helm install pg-ha-release dbkernel/postgresql-ha
```

## 2.2. operator 方式安装

以`clickhouse-operator`为例说明。

### 2.2.1. 添加 helm 仓库：
```bash
helm repo add dbkernel https://dbkernel.github.io/helm-charts/
helm repo update
```

### 2.2.2. 安装 operator

- 方法一：
```bash
wget https://dbkernel.github.io/helm-charts/clickhouse-operator-install.yaml
kubectl apply -f clickhouse-operator-install.yaml
```
输出内容如下：
```
customresourcedefinition.apiextensions.k8s.io/clickhouseinstallations.clickhouse.dbkernel.com configured
customresourcedefinition.apiextensions.k8s.io/clickhouseinstallationtemplates.clickhouse.dbkernel.com configured
customresourcedefinition.apiextensions.k8s.io/clickhouseoperatorconfigurations.clickhouse.dbkernel.com configured
serviceaccount/clickhouse-operator created
clusterrolebinding.rbac.authorization.k8s.io/clickhouse-operator-kube-system created
configmap/etc-clickhouse-operator-files created
configmap/etc-clickhouse-operator-confd-files created
configmap/etc-clickhouse-operator-configd-files created
configmap/etc-clickhouse-operator-templatesd-files created
configmap/etc-clickhouse-operator-usersd-files created
deployment.apps/clickhouse-operator created
service/clickhouse-operator-metrics created
```

- 方法二：
```bash
helm install ck-operator-release dbkernel/clickhouse-operator
```
输出内容如下：
```bash
NAME: ck-operator-release
LAST DEPLOYED: Wed Aug 11 08:05:50 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

### 2.2.3. 查看相关 pods
```bash
kubectl get all --selector=app=clickhouse-operator -n kube-system
kubectl get pods -n kube-system
```

### 2.2.4. 安装 clickhouse-cluster

**问题：什么是CR、CRD及二者的关系？**
>`charts/clickhouse-operator-install.yaml`中的 CRD 表示对CR（自定义资源）的定义，而其所操作的CR就是 `clickhouse-cluster`。

```bash
# add repo 在2.2.1小节已经完成
helm install clickhouse-cluster dbkernel/clickhouse-cluster -n kube-system
```

# License

This helm chart is published under the Apache License, Version 2.0. See LICENSE.md for more information.

Copyright (c) by [DBKernel](https://dbkernel.github.io/).
