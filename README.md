# docker-compose
Docker-Compose 部署gitlab+redmine开发环境,并使用nginx反向代理

----------------------------------------------------------------

## docker centos

1. 安装yum-utils 提供了 yum-config-manager 可以安装yum源
```
sudo yum install -y yum-utils
```
2. 设置yum源
```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo  //官方源
```
```
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo //阿里源
```
```
sudo yum-config-manager --add-repo https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo //清华源
```
3. 安装docker
 ```
 sudo yum install docker-ce docker-ce-cli containerd.io
 ```
4. 启动docker
```
sudo systemctl start docker
```
5. 验证docker
```
sudo docker run hello-world
```
6. 镜像加速  
> 通过修改daemon配置文件/etc/docker/daemon.json来使用阿里云镜像加速器
```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://阿里云镜像加速器地址"] 
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

[参考1：Docker 官方](https://docs.docker.com/engine/install/centos/)  
[参考2：Docker 菜鸟教程](https://www.runoob.com/docker/centos-docker-install.html)

----------------------------------------------------------------

## docker-compose centos

----------------------------------------------------------------

## linux alias
> docker-compose取别名以减少命令字符
1. 编辑bash命令文件
```
sudo vim ~/.bashrc   //编辑对应的bashrc文件
```
2. 具体位置添加对应的alias命令
```
alias dc='dc-compose' //添加命令
```
3. 更新执行bashrc文件，使alias命令生效
```
. ~/.bashrc  //更新生效相关的bashrc文件
```
