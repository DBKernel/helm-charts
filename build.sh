#!/bin/bash

if [ ! -d ./docs ]; then
    mkdir ./docs
fi

dbs=(
    "postgresql-ha=6.9.1"
    "clickhouse=0.1.0" # helm
    "clickhouse-operator=0.14.0"
    "clickhouse-cluster=0.14.0" # for operator
)

repo=https://dbkernel.github.io/helm-charts/

set -x

for db in ${dbs[@]}; do
    db_name=$(echo ${db} | cut -d = -f 1)
    db_version=$(echo ${db} | cut -d = -f 2)

    rm -f ./docs/$db_name*
    helm package charts/${db_name}
    mv ${db_name}-${db_version}.tgz ./docs
    if [ "${db_name}" == "clickhouse-operator" ]; then
        cp charts/clickhouse-operator-install.yaml docs
    fi
    helm repo index --url $repo ./docs
done

set +x
