
## 如何构建helm repo？

>**前提：** 已开启github pages，且选定路径为`/docs`。

### 方法一：脚本自动构建

1. 执行`build.sh`即可自动构建出对应的tgz文件。
2. 将tgz文件等push到github。

### 方法二：手动构建

以`postgresql-ha`为例说明：
1. 打包：
```bash
helm package charts/postgresql-ha
```
4. 构建`helm repo`：
```bash
helm repo index --url https://dbkernel.github.io/helm-charts/ ./docs
```
5. 将`tgz`文件放到`./docs`：
```bash
mv postgresql-ha-x.x.x.tgz to ./docs
```
6. 将`/docs`推送到github。

## 如何安装到Kubernetes？

```bash
helm repo add dbkernel-repo https://dbkernel.github.io/helm-charts/
helm install pg-ha-release dbkernel-repo/postgresql-ha
```


