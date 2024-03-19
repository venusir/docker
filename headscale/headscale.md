## **Headscale 部署**

Headscale 部署在 Linux 主机上，随便找台有独立ip的vps就可以了，但是要注意，如果需要穿透的内网无法打洞成功那么流量就会由服务器中转，这意味着穿透后的速度会直接的受限于节点跟服务器之间的网络情况，所以尽量选择离你近的服务器，即使打洞失败了，至少网络还是稳定的，通畅的。

项目主页：[https://github.com/juanfont/headscale/](https://github.com/juanfont/headscale/)

```
# 下载服务端
wget --output-document=/usr/local/bin/headscale \
https://github.com/juanfont/headscale/releases/download/v0.17.0-alpha4/headscale_0.17.0-alpha4_linux_amd64
# 设置执行权限
chmod +x /usr/local/bin/headscale
```

准备

```
#创建配置目录：
mkdir -p /etc/headscale

#创建目录用来存储数据与证书：
mkdir -p /var/lib/headscale

#创建空的 SQLite 数据库文件：
touch /var/lib/headscale/db.sqlite

#　从example 创建 Headscale 配置文件：
wget https://github.com/juanfont/headscale/raw/main/config-example.yaml -O /etc/headscale/config.yaml
```

-   `server_url` 设置为 `http://<PUBLIC_IP>:8080`，将 `<PUBLIC_IP>` 替换为公网 IP 或者域名。
-   可自定义私有网段，也可同时开启 IPv4 和 IPv6：
-   `ip_prefixes: # - fd7a:115c:a1e0::/48 - 10.1.0.0/16`
-   随机端口要打开，否则同一个内网中多个终端会有问题
-   randomize\_client\_port: true

创建 SystemD service 配置文件：

```
# /etc/systemd/system/headscale.service
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
```

```
# 创建 headscale 用户：

useradd headscale -d /home/headscale -m

# 修改 /var/lib/headscale 目录的 owner：

chown -R headscale:headscale /var/lib/headscale

#修改配置文件中的&nbsp;`unix_socket`：


unix_socket: /var/run/headscale/headscale.sock

#　Reload SystemD 以加载新的配置文件：

systemctl daemon-reload

#启动 Headscale 服务并设置开机自启：

systemctl enable --now headscale

#　查看运行状态：

systemctl status headscale

#　查看占用端口：

ss -tulnp|grep headscale

# 创建一个 namespace，以便后续客户端接入，例如：
headscale namespaces create default

# 查看命名空间：

headscale namespaces list
```
