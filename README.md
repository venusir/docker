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

[参考1：Docker 官方](https://docs.docker.com/engine/install/centos/)  
[参考2：Docker 菜鸟教程](https://www.runoob.com/docker/centos-docker-install.html)

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
