#!/bin/bash

# 下载 mosdns
wget https://github.com/IrineSistiana/mosdns/releases/download/v5.1.3/mosdns-linux-amd64.zip
# 下载配置
wget https://github.com/rqysir609/docker/raw/main/dns_v2raya/dns_v2raya.zip

# 创建所需目录
mkdir /etc/mosdns
mkdir /var/mosdns
touch /var/disable-ads.txt
mv dns_v2raya/mosdns/etc/mosdns/* /etc/mosdns
mv dns_v2raya/mosdns/var/mosdns/* /var/mosdns
mv dns_v2raya/mosdns/v2dat /opt
chmod +x /opt/v2dat

# 安装 mosdns

# 解压
unzip -o -d mosdns mosdns-linux-amd64.zip
# 把mosdns软件移到绝对工作目录
mv /root/mosdns/mosdns /usr/bin/
chmod +x /usr/bin/mosdns
# mosdns service install -d 工作目录绝对路径 -c 配置文件路径
mosdns service install -d /usr/bin -c /etc/mosdns/config.yaml
# 启动mosdns并设置开机自启
mosdns service start
systemctl enable mosdns.service

# 检查状态
systemctl status mosdns.service


# 安装 adguardhome 的代码

# 下载AdGuardHome到本机,三选一都是安装脚本,能用就行
wget --no-verbose -O - https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v

# 启动
systemctl start AdGuardHome

# 状态
systemctl status AdGuardHome

# 开机自启
systemctl enable AdGuardHome

# 重启
systemctl restart AdGuardHome

# 停止
systemctl stop AdGuardHome

# 编辑cron
mkdir /etc/mycron
mv dns_v2raya//mosdns/mosdns_update.sh /etc/mycron
chmod +x /etc/mycron/mosdns_update.sh

# 添加
echo "30 4 * * * root /etc/mycron/mosdns_update.sh" >> /etc/crontab

rm -rf dns_v2raya
rm -rf dns_v2raya.zip
rm -rf mosdns-linux-amd64.zip
