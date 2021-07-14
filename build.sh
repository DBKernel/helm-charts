#!/bin/bash
db_name=postgresql-ha
db_version=6.9.1

repo=https://dbkernel.github.io/helm-charts/

set -x

helm package charts/${db_name}
helm repo index --url $repo ./docs
mv ${db_name}-${db_version}.tgz ./docs

set +x
