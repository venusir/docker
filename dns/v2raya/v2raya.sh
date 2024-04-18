#!/bin/bash

# 开启 ipv4 转发
# 填写如下内容开启ipv4转发,并关闭ipv6
echo "net.ipv4.ip_forward=1
net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf

# 检查
sysctl -p

# 添加公钥和软件源
# 报错的话可以试试逐条复制
wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/keyrings/v2raya.asc

echo "deb [signed-by=/etc/apt/keyrings/v2raya.asc] https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list

sudo apt update

sudo apt install v2raya v2ray #v2ray内核
# sudo apt install v2raya xray  #xray内核
# 启动并设置自启
sudo systemctl start v2raya.service
# 开机自启
sudo systemctl enable v2raya.service

