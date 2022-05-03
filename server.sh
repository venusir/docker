#!/bin/bash

local_ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"​`
echo "${local_ip}"

#创建swarm（要保存初始化后token保存至swarm_token.log
docker swarm init --advertise-addr ${local_ip} |tee swarm_token.log
#获取swarm token
swarm_token=$(sed -n '/--token/p' swarm_token.log)

echo "${swarm_token}"

#添加节点
docker swarm join --token ${swarm_token} "${local_ip}":2377

#下载nginx默认配置
curl -O https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx/nginx.conf
#下载nginx默认配置
curl -o ./conf.d/default.conf --create-dirs https://github.com/rqysir609/docker/blob/main/nginx/nginx/conf.d/default.conf
#下载nginx compose文件
curl -O https://raw.githubusercontent.com/rqysir609/docker/main/nginx/nginx-compose.yml

#部署
docker stack deploy -c nginx-compose.yml nginx
