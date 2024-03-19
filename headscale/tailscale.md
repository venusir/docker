## linux客户端

直接下载。查看最新版本：[https://pkgs.tailscale.com/stable/](https://pkgs.tailscale.com/stable/)

```
wget https://pkgs.tailscale.com/stable/tailscale_1.28.0_amd64.tgz
tar zxvf tailscale_1.28.0_amd64.tgz x tailscale_1.28.0_amd64/
```

将二进制文件复制到官方软件包默认的路径下：

```
cp tailscale_1.28.0_amd64/tailscaled /usr/sbin/tailscaled
cp tailscale_1.28.0_amd64/tailscale /usr/bin/tailscale
chmod +x /usr/sbin/tailscaled
chmod +x /usr/bin/tailscale
```

将 systemD service 配置文件复制到系统路径下：

```
cp tailscale_1.28.0_amd64/systemd/tailscaled.service /lib/systemd/system/tailscaled.service
```

将环境变量配置文件复制到系统路径下：

```
cp tailscale_1.28.0_amd64/systemd/tailscaled.defaults /etc/default/tailscaled
```

```
# 启动 tailscaled.service 并设置开机自启：
systemctl enable --now tailscaled
# 查看服务状态：
systemctl status tailscaled
```

Tailscale 接入：

```
tailscale up --login-server=http://ip:8080 --accept-routes=true --accept-dns=false
# 如果申请为虚拟网关，需要指定
tailscale up --login-server=http://ip:8080 --accept-routes=true --accept-dns=false --advertise-routes=192.168.188.0/24
# 打开转发
echo 'net.ipv4.ip_forward = 1' | tee /etc/sysctl.d/ipforwarding.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/ipforwarding.conf
sysctl -p /etc/sysctl.d/ipforwarding.conf
```

执行完上面的命令后，会出现下面的信息：

To authenticate, visit:

[http://xxxxxx:8080/register?key=905cf165204800247fbd33989dbc22be95c987286c45aac303393704](http://xxxxxx:8080/register?key=905cf165204800247fbd33989dbc22be95c987286c45aac303393704)

在浏览器中打开该链接，就会出现如下的界面：

![https://jsdelivr.icloudnative.io/gh/yangchuansheng/imghosting3@main/uPic/2022-03-20-17-06-08qWbz.png](https://jsdelivr.icloudnative.io/gh/yangchuansheng/imghosting3@main/uPic/2022-03-20-17-06-08qWbz.png)

将其中的命令复制粘贴到 headscale 所在机器的终端中，并将 NAMESPACE 替换为前面所创建的 namespace。

```
headscale -n default nodes register --key d1614a1407b7554cd368db21f383197802d9c95249130d7b3db256458d9a4043
# 注册成功，查看注册的节点：
headscale nodes list
# 许可路由的话，通过上个命令就可以看到linux节点的id，就是1，2，3，……
# 查看改节点的路由，假如id是1
headscale routes list -i 1
# 许可网关
headscale routes enable -i 1 -r "192.168.188.0/24"
# 再次查看虚拟网关状态，id是1
headscale routes list -i 1
# enabled就是已经启用了
```

回到 Tailscale 客户端所在的 Linux 主机，可以看到 Tailscale 会自动创建相关的路由表和 iptables 规则。路由表可通过以下命令查看：

```
ip route show table 52
```
