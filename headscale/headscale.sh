#!/bin/bash

DOMAINNAME=rqysir609.cc

# -----------------------tool--------------------------------
# 更新apt
apt-get update

# 安装所需工具
apt-get install -y curl

# -----------------------nginx--------------------------------
# 安装nginx
apt-get install nginx

# 启动nginx
systemctl start nginx

# 开机启动nginx
systemctl enable nginx

# 创建配置目录：
mkdir -p /etc/headscale

# -----------------------acme--------------------------------

# 创建证书目录
CERTPATH=/etc/cert
mkdir -p /etc/cert

# 安装acme
curl https://get.acme.sh | sh

# 添加软链接
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh

# 切换CA机构
acme.sh --set-default-ca --server letsencrypt

# 申请证书
acme.sh  --issue --dns dns_cf -d ${DOMAINNAME} -d *.${DOMAINNAME} -k ec-256

# 安装证书
acme.sh --install-cert -d ${DOMAINNAME} --ecc --key-file ${CERTPATH}/${DOMAINNAME}.key  --fullchain-file ${CERTPATH}/${DOMAINNAME}.crt --reloadcmd "systemctl force-reload nginx"

# -----------------------docker--------------------------------

# 安装Docker
curl -sSL https://get.docker.com/ | sh

# -----------------------headscale--------------------------------

# 创建配置目录
mkdir -p /etc/headscale

# 创建目录用来存储数据与证书
mkdir -p /var/lib/headscale

# 创建空的 SQLite 数据库文件
touch /var/lib/headscale/db.sqlite

# 下载Headscale 配置文件
wget https://github.com/juanfont/headscale/raw/main/config-example.yaml -O /etc/headscale/config.yaml

# 修改相关配置文件，比如配置文件中配置 127.0.0.1 的话，那么就只能本机访问。这里修改为 0.0.0.0 那么就所有的 ip 都能访问。
sed -i 's/127.0.0.1/0.0.0.0/g' /home/docker/headscale/config/config.yaml

# 域名填自己的
sed -i 's#http://0.0.0.0:8080#https://headscale.${DOMAINNAME}#g' /etc/headscale/config.yaml

# 修改 dns 配置文件，如果不进行修改，那么登录时选择接受服务器的 dns 地址就会出现域名无法解析的情况。注意，这里的 dns 地址可以有多个，如果有需要自行添加即可。
#sed -i 's/1\.1\.1\.1/119.29.29.29/g' /home/docker/headscale/config/config.yaml

# 客户端可以通过 主机名 + 用户 + 基础域名 访问任意一台终端，所以这里修改下基础域名[根域名]，根据自己的实际域名进行填写。
sed -i 's/example.com/${DOMAINNAME}/' /etc/headscale/config.yaml

# 设置客户端随机端口，这里是听见有说不开机随机端口可能出现只能加入一台客户端的情况，为了保险还是选择开启。
sed -i 's/randomize_client_port: false/randomize_client_port: true/' /etc/headscale/config.yaml

#启动headscale
docker run -d \
--name headscale \
--restart always \
-v /etc/headscale:/etc/headscale/ \
-v /var/lib/headscale:/var/lib/headscale \
-p 8080:8080 \
-p 9090:9090 \
--restart always \
headscale/headscale:0.22.3 \
headscale serve

# -----------------------web-ui--------------------------------

# 搭建web-ui
docker run -d \
--name headscale-webui \
--restart always \
-v /etc/headscale:/etc/headscale/:ro \
-v /etc/headscale/web-ui/data:/data \
-u root \
-p 5000:5000 \
-e HS_SERVER=https://headscale.${DOMAINNAME}  \ # 
-e DOMAIN_NAME=https://headscale.${DOMAINNAME}  \ # 反向代理后的域名，必须要先设置好！
-e SCRIPT_NAME=/admin \
-e AUTH_TYPE=Basic \
-e BASIC_AUTH_USER=admin \
-e BASIC_AUTH_PASS=admin \
-e KEY="2uHP6BSVocX+wcWU5mzuXA7JvnZA70UaTadB8L1heOo=" \
--restart always \
ifargle/headscale-webui:latest

cat > /etc/nginx/conf.d/headscale.${DOMAINNAME}.conf << EOF
server {
    listen       443 ssl;
    listen  [::]:443 ssl;
    server_name  headscale.${DOMAINNAME};
    ssl_certificate  /etc/cert/${DOMAINNAME}.cer;
    ssl_certificate_key /etc/cert/${DOMAINNAME}.key;
 
    location ^~/ {
        proxy_pass http://localhost:8080/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $server_name;
        proxy_redirect https:// https://;
        proxy_buffering off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
    }
 
    location ^~/admin/ {
        proxy_pass http://localhost:5000/admin/;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
 
server {
    listen 80;
    server_name  headscale.${DOMAINNAME};
    rewrite ^(.*)$ https://$host:443$1 permanent;
}
EOF

# -----------------------derp--------------------------------

#搭建derp
docker run -d \
--name derper \
-p 12345:12345 \
-p 3478:3478/udp \
-e DERP_ADDR=:12345 \
-e DERP_DOMAIN=derper.${DOMAINNAME} \
-e DERP_VERIFY_CLIENTS=false \
--restart always \
yangchuansheng/derper

cat > /etc/nginx/conf.d/derper.${DOMAINNAME}.conf << EOF
server {
    listen       443 ssl;
    listen  [::]:443 ssl;
    server_name  derper.${DOMAINNAME};
    ssl_certificate  /etc/cert/${DOMAINNAME}.cer;
    ssl_certificate_key /etc/cert/${DOMAINNAME}.key;
 
    location / {
        proxy_pass http://localhost:12345/;
        proxy_redirect https:// https://;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        add_header Content-Security-Policy upgrade-insecure-requests;
    }
}
 
server {
    listen 80;
    server_name  derper.${DOMAINNAME};
    rewrite ^(.*)$ https://$host:443$1 permanent;
}
EOF

#设置了强制跳转 https，如果有需要可以不设置，如果没有域名请不需要配置。

#配置修改后，记得重启下 nginx，这里需要使用域名或者 ip + 端口能够访问到 derp 页面。

#创建derp.yaml
cat > var/headscale/derp.yaml << EOF
regions:
  900:
    regionid: 900
    regioncode: ts
    regionname: Tencent Shanghai
    nodes:
      - name: 900a
        regionid: 900
        hostname: derper.${DOMAINNAME}
        # ipv4: ip
        stunport: 3478
        stunonly: false
        derpport: 443
EOF