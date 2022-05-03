#!/bin/bash

if [ -f /home/docker/nginx-compose.yml ] 
then
  echo "Exists"
else
  echo "No Exists"
fi
#下载nginx默认配置
#curl -O https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx/nginx.conf
#下载nginx默认配置
#curl -o ./conf.d/default.conf --create-dirs https://github.com/rqysir609/docker/blob/main/nginx/nginx/conf.d/default.conf
#下载nginx compose文件
#curl -O https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx-compose.yml

#部署

