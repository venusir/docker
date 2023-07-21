#!/bin/bash

apt-get update

echo "安装Docker"
# curl -sSL https://get.docker.com/ | sh

mkdir -p /etc/nginx
mkdir -p /etc/nginx/conf.d
mkdir -p /usr/share/nginx/html

CF_Token="AAA"
CF_Zone_ID="AAA"
CF_Account_ID="AAA"

# 生成容器
docker run --name nginx -p 9001:80 -d nginx
# 将容器nginx.conf文件复制到宿主机
docker cp nginx:/etc/nginx/nginx.conf /etc/nginx/nginx.conf
# 将容器conf.d文件夹下内容复制到宿主机
docker cp nginx:/etc/nginx/conf.d /etc/nginx/conf.d
# 将容器中的html文件夹复制到宿主机
docker cp nginx:/usr/share/nginx/html /usr/share/nginx/html
# 删除正在运行的nginx容器
docker rm -f nginx

# 导入Docker-Compose
cat > $PWD/docker-compose.yml << EOF
version: "3"
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    restart: unless-stopped
    network_mode: host
    environment:
      - PGID=1000
      - PUID=1000
    volumes:
      - /etc/nginx/nginx.conf:/etc/nginx/nginx.conf
      - /etc/nginx/conf.d:/etc/nginx/conf.d
      - /var/www/html:/var/www/html
      - /var/log/nginx:/var/log/nginx
      - /root/certs:/root/certs
 
  acme:
    image: neilpang/acme.sh
    container_name: acme.sh
    restart: unless-stopped
    network_mode: host
    environment:
      - PGID=1000
      - PUID=1000
      - CF_Token=${CF_Token}
      - CF_Zone_ID=${CF_Zone_ID}
      - CF_Account_ID=${CF_Account_ID}
    volumes:
      - /root/acme.sh:/acme.sh
      - /root/certs:/root/certs
EOF

# 首次运行先进入容器生成证书
# acme.sh --issue --dns dns_dp -d sleele.com -d *.sleele.com
# 第一次需要用自己的邮箱注册 docker exec -i acme-ecc acme.sh --register-account -m my@example.com
# docker exec -i acme-ecc acme.sh --issue --dns dns_dp -d sleele.com -d *.sleele.com --keylength ec-256
# 然后部署证书到指定文件夹
# acme.sh --deploy -d sleele.com --deploy-hook docker
# docker exec -i acme-ecc acme.sh --deploy -d sleele.com --ecc --deploy-hook docker
