## Welcome to postgresql-ha Pages

update github pages:
1. create chart directory, for example, ./tar
2. execute command:
```
helm package tar/
cd ..
helm repo index --url https://drdstech.github.io/postgresql-ha/ ./docs
```
3. copy postgresql-ha-x.x.x.tgz to ./docs
4. push to github

use the helm repo in Kubernetes:
```
helm repo add pg-ha https://drdstech.github.io/postgresql-ha/
helm install my-release pg-ha/postgresql-ha
```
