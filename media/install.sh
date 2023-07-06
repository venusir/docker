#!/bin/bash

#下载nginx默认配置
if [ -f ./NasTool.yml ]; then
  rm -rf NasTool.yml
fi

#下载nginx compose文件
curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/media/docker-compose.yml -O

#部署
sudo docker-compose up -d