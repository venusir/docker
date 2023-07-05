#!/bin/bash

#下载nginx compose文件
curl -fsSL https://raw.githubusercontent.com/rqysir609/docker/main/media/NasTool.yml -O

#部署
sudo docker-compose -f NasTool.yml up -d