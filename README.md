
[![License](https://img.shields.io/badge/license-Apache-green.svg)](./LICENSE)
[![](https://github.com/dbkernel/helm-charts/workflows/helm-charts%2Frelease/badge.svg?branch=master)](https://github.com/dbkernel/helm-charts/actions)

# 1. 如何构建helm repo？

>**前提：** 已开启github pages，且选定路径为`/docs`。

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
4. 将`/docs`推送到 github。

# 2. 如何安装到Kubernetes

## 2.1. 安装 helm chart

以`postgresql-ha`为例说明：

```bash
helm repo add dbkernel https://dbkernel.github.io/helm-charts/
helm install pg-ha-release dbkernel/postgresql-ha
```

## 2.2. 安装 operator

以`clickhouse-operator`为例说明：
```bash
helm repo add dbkernel https://dbkernel.github.io/helm-charts/
helm repo update
helm install ck-operator-release dbkernel/clickhouse-operator

wget https://github.com/DBKernel/helm-charts/blob/main/charts/clickhouse-operator-install.yaml
kubectl apply -f clickhouse-operator-install.yaml
```

# License

This helm chart is published under the Apache License, Version 2.0. See LICENSE.md for more information.

Copyright (c) by [DBKernel](https://dbkernel.github.io/).
