#!/bin/bash

#初始化swarm集群
docker swarm init

#下载默认配置
curl -O https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx/nginx.conf
curl -o ./conf.d/default.conf --create-dirs https://github.com/rqysir609/docker/blob/main/nginx/nginx/conf.d/default.conf
