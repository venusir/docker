#!/bin/bash

# 安装AdguardHome

#安装所需工具
apt update
apt install iptables -y
apt install zip -y
apt install curl -y

#启用ipv4转发以及禁用ipv6
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf

#检查是否禁用
sysctl -p

#清楚DNS缓存（debian12不需要）
#systemctl restart systemd-resolved.service

#AdGuardHmoe github
#https://github.com/AdguardTeam/AdGuardHome

#下载AdGuardHome到本机
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v

#启动
systemctl start AdGuardHome

#状态
systemctl status AdGuardHome

#开机自启
systemctl enable AdGuardHome

#重启
#systemctl restart AdGuardHome

#停止
#systemctl stop AdGuardHome

#mosdns

#下载mosdns
wget https://github.com/IrineSistiana/mosdns/releases/download/v5.1.3/mosdns-linux-amd64.zip
#下载配置文件
wget https://github.com/rqysir609/docker/raw/main/Dns/DnsConfig.zip

#创建所需目录及文件
mkdir /etc/mosdns
mkdir /var/mosdns
touch /var/disable-ads.txt

#解压mosdns
unzip -o -d mosdns mosdns-linux-amd64.zip
#解压配置文件
unzip DnsConfig.zip

#移动所需文件到指定目录
mv /root/mosdns/mosdns /usr/bin/
chmod +x /usr/bin/mosdns
mv etc/mosdns/* /etc/mosdns/
mv var/mosdns/* /var/mosdns/

#删除临时文件夹
rm -rf mosdns
rm -rf etc
rm -rf var

#删除临时文件
rm -rf mosdns-linux-amd64.zip
rm -rf DnsConfig.zip

#安装服务
#mosdns service install -d 工作目录绝对路径 -c 配置文件路径
mosdns service install -d /usr/bin -c /etc/mosdns/config.yaml

#启动mosdns
mosdns service start

#开机启动
systemctl enable mosdns.service

检查状态
systemctl status mosdns.service