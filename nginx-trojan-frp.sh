#!/bin/bash

#下载nginx默认配置
curl https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx/nginx.conf -O
#下载nginx默认配置
curl https://github.com/rqysir609/docker/blob/main/nginx/nginx/conf.d/default.conf -o ./conf.d/default.conf --create-dirs
#下载nginx compose文件
curl https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx-compose.yml -O

#部署

