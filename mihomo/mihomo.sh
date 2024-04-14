#!/bin/bash

echo "开始下载 mihomo"
wget https://github.com/MetaCubeX/mihomo/releases/download/v1.18.3/mihomo-linux-amd64-compatible-v1.18.3.gz
echo "mihomo 下载完成"

echo "开始解压"
gunzip mihomo-linux-amd64-compatible-v1.18.3.gz
echo "解压完成"

echo "开始重命名"
mv mihomo-linux-amd64-compatible-v1.18.3 mihomo
echo "重命名完成"

echo "开始添加执行权限"
chmod u+x mihomo
echo "执行权限添加完成"

echo "开始创建 /etc/mihomo 目录"
sudo mkdir -p /etc/mihomo
echo "/etc/mihomo 目录创建完成"

echo "开始复制 mihomo 到 /usr/local/bin"
sudo cp mihomo /usr/local/bin
echo "复制完成"

echo "开始安装ui界面"
git clone https://github.com/metacubex/metacubexd.git -b gh-pages /etc/mihomo/ui
echo "ui界面安装完成"

# echo "更新UI"
# git -C /etc/mihomo/ui pull -r

echo "开始设置 转发"
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf
echo "转发设置完成"

echo "开始创建 systemd 服务"

tee /etc/systemd/system/mihomo.service > /dev/null <<EOF
[Unit]
Description=mihomo daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/mihomo -d /etc/mihomo

[Install]
WantedBy=multi-user.target
EOF

echo "重载 systemd"
systemctl daemon-reload

echo "启用 mihomo 服务（开机、重启系统后自动启动）"
systemctl enable mihomo

echo "立即启动 mihomo 服务"
systemctl start mihomo

echo "检查 mihomo 服务状态"
systemctl status mihomo

echo "systemd 服务创建完成"