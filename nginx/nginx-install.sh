#!/bin/bash

#下载nginx默认配置
if [ ! -f ./nginx.conf ]; then
  curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx/nginx.conf -O
fi

#下载nginx默认配置
if [ ! -f ./conf.d/default.conf ]; then
  curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/nginx/conf/conf.d/default.conf -o ./conf.d/default.conf --create-dirs
fi

#下载nginx compose文件
curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx-install.yml -O

#部署
docker-compose -f nginx-install.yml up -d

