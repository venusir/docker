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