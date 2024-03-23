#!/bin/bash

#下载headscale二进制文件
wget --output-document=/usr/local/bin/headscale \
   https://github.com/juanfont/headscale/releases/download/v<HEADSCALE VERSION>/headscale_<HEADSCALE VERSION>_linux_<ARCH>

chmod +x /usr/local/bin/headscale

#创建配置目录：
 mkdir -p /etc/headscale
 
 #创建目录用来存储数据与证书：
 mkdir -p /var/lib/headscale
 
 #创建空的 SQLite 数据库文件：
 touch /var/lib/headscale/db.sqlite

#创建 Headscale 配置文件：
#wget https://github.com/juanfont/headscale/raw/main/config-example.yaml -O /etc/headscale/config.yaml

#修改配置文件，将 server_url 改为公网 IP 或域名。如果是国内服务器，域名必须要备案。
#如果暂时用不到 DNS 功能，可以先将 magic_dns 设为 false。
#server_url 设置为 http://<PUBLIC_ENDPOINT>:8080，将 <PUBLIC_ENDPOINT> 替换为公网 IP 或者域名。
#建议打开随机端口，将 randomize_client_port 设为 true。
#可自定义私有网段，也可同时开启 IPv4 和 IPv6：
#ip_prefixes:
#  # - fd7a:115c:a1e0::/48
#  - 100.64.0.0/16

#创建 SystemD service 配置文件：

cat > /etc/systemd/system/headscale.service << EOF
[Unit]
Description=headscale controller
After=syslog.target
After=network.target

[Service]
Type=simple
User=headscale
Group=headscale
ExecStart=/usr/local/bin/headscale serve
Restart=always
RestartSec=5

# Optional security enhancements
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=yes
ReadWritePaths=/var/lib/headscale /var/run/headscale
AmbientCapabilities=CAP_NET_BIND_SERVICE
RuntimeDirectory=headscale

[Install]
WantedBy=multi-user.target
EOF

#创建 headscale 用户：
useradd headscale -d /home/headscale -m

#修改 /var/lib/headscale 目录的 owner
chown -R headscale:headscale /var/lib/headscale

#修改配置文件中的 unix_socket：
#unix_socket: /var/run/headscale/headscale.sock

#Reload SystemD 以加载新的配置文件：
systemctl daemon-reload

#启动 Headscale 服务并设置开机自启：
systemctl start  headscale
systemctl enable  headscale

#查看运行状态：
systemctl status headscale

#查看占用端口：
ss -tulnp|grep headscale





