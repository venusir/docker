#!/bin/bash

#------------------------------------------nginx-----------------------------------------------------
#下载nginx默认配置
if [ ! -f ./nginx.conf ]; then
  curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx/nginx.conf -o ./nginx/nginx.conf --create-dirs
fi

#下载nginx默认配置
if [ ! -f ./conf.d/default.conf ]; then
  curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/nginx/conf/conf.d/default.conf -o ./nginx/conf.d/default.conf --create-dirs
fi
#------------------------------------------nginx-----------------------------------------------------

#------------------------------------------trojan-----------------------------------------------------

mkdir -p ./trojan-go

cat > ./trojan-go/config.json <<EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 1443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "123456"
    ],
    "ssl": {
        "cert": "server.crt",
        "key": "server.key",
        "sni": "trojan.venusir.net",
    }
}
EOF

#------------------------------------------trojan-----------------------------------------------------

#下载nginx compose文件
curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/nginx-trojan-frp/docker-compose.yml -O

#部署
docker-compose up -d

