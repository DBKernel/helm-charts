# Helm Chart for ClickHouse Operator

## Installation

### Add Helm Repository

```
$ helm repo add dbkernel https://dbkernel.github.io/helm-charts/charts/
$ helm repo update

```

### Install to Kubernetes

```
$ helm install --generate-name dbkernel/clickhouse-operator

```

## License

This helm chart is published under the Apache License, Version 2.0. See LICENSE.md for more information.

Copyright (c) by [DBKernel](https://dbkernel.github.io/).
