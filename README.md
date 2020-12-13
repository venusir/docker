# docker-compose
Docker-Compose 部署gitlab+redmine开发环境,并使用nginx反向代理

## docker centos

* 安装yum-utils 提供了 yum-config-manager 可以安装yum源
```
sudo yum install -y yum-utils
```
* 设置yum源
  * 官方源
  ```
  sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
  ```
  * 阿里源
  ```
  sudo yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  ```
  * 清华源
  ```
  sudo yum-config-manager \
    --add-repo \
    https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo
  ```
* 安装docker
  * 安装最新版本
  ```
  sudo yum install docker-ce docker-ce-cli containerd.io
  ```
  * 安装指定版本
    * 列出并排序您存储库中可用的版本
    ```
    yum list docker-ce --showduplicates | sort -r

    docker-ce.x86_64  3:18.09.1-3.el7                     docker-ce-stable
    docker-ce.x86_64  3:18.09.0-3.el7                     docker-ce-stable
    docker-ce.x86_64  18.06.1.ce-3.el7                    docker-ce-stable
    docker-ce.x86_64  18.06.0.ce-3.el7                    docker-ce-stable
    ```
    * 通过其完整的软件包名称安装特定版本，该软件包名称是软件包名称（docker-ce）加上版本字符串（第二列），从第一个冒号（:）一直到第一个连字符，并用连字符（-）分隔。例如：docker-ce-18.09.1
    ```
    sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
    ```
* 启动docker
```
sudo systemctl start docker
```
* 验证docker
```
sudo docker run hello-world
```
* 参考文档  
  [参考1：Docker 官方](https://docs.docker.com/engine/install/centos/)  
  [参考2：Docker 菜鸟教程](https://www.runoob.com/docker/centos-docker-install.html)

## docker-compose centos

## linux alias
给docker-compose取别名以减少命令字符
* 编辑bash命令文件
```
sudo vim ~/.bashrc   //编辑对应的bashrc文件
```
* 具体位置添加对应的alias命令
```
alias dc='dc-compose' //添加命令
```
* 更新执行bashrc文件，使alias命令生效
```
. ~/.bashrc  //更新生效相关的bashrc文件
```
