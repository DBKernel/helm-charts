## Welcome to postgresql-ha Pages

1. create chart directory, for example, ./tar
2. execute command:
```
helm package tar/
cd ..
helm repo index --url https://drdstech.github.io/postgresql-ha/ ./docs
```
