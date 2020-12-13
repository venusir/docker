# docker-compose
Docker-Compose 部署gitlab+redmine开发环境,并使用nginx反向代理

## docker centos
[CentOS Docker 安装](https://www.runoob.com/docker/centos-docker-install.html)
[Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

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
