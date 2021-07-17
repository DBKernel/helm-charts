#!/bin/bash
#db_name=postgresql-ha
#db_version=6.9.1

#db_name=clickhouse-cluster
#db_version=0.14.0

db_name=clickhouse-operator
db_version=0.14.0

repo=https://dbkernel.github.io/helm-charts/

set -x

rm -f ./docs/$db_name*
helm package charts/${db_name}
mv ${db_name}-${db_version}.tgz ./docs
if [ "${db_name}" == "clickhouse-operator" ]; then
    cp charts/clickhouse-operator-install.yaml docs
fi
helm repo index --url $repo ./docs

set +x
