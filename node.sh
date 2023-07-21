#!/bin/bash

# 证书路径
CERTPATH=/etc/cert
mkdir -p /etc/cert

# 输入域名
read -p "请输入域名:" DOMAINNAMW
# 输入Cloudflare Token
read -p "请输入Cloudflare Token:" CFTOKEN
# 输入Cloudflare Account
read -p "请输入Cloudflare Account:" CFACCOUNT

export CF_Token="${CFTOKEN}"
export CF_Account_ID="${CFACCOUNT}"

# 更新软件源
apt-get update

# 安装curl
apt-get install curl

# 启用 BBR TCP 拥塞控制算法
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

# 安装x-ui：
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

# 安装nginx
apt-get install nginx

cat > /etc/nginx/conf.d/${DOMAINNAMW}.conf << EOF
server {
	listen 443 ssl;	
    listen [::]:443 ssl;
	
	server_name ${DOMAINNAMW};  #你的域名
	ssl_certificate       ${CERTPATH}/${DOMAINNAMW}.crt;  #证书位置
	ssl_certificate_key   ${CERTPATH}/${DOMAINNAMW}.key;  #私钥位置
	
	ssl_session_timeout 1d;
	ssl_session_cache shared:MozSSL:10m;
	ssl_session_tickets off;
	ssl_protocols    TLSv1.2 TLSv1.3;
	ssl_prefer_server_ciphers off;

	location / {
		proxy_pass http://ransys.cn/; #伪装网址
		proxy_redirect off;
		proxy_ssl_server_name on;
		sub_filter_once off;
		sub_filter "ransys.cn" \$server_name;
		proxy_set_header Host "ransys.cn";
		proxy_set_header Referer \$http_referer;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header User-Agent \$http_user_agent;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto https;
		proxy_set_header Accept-Encoding "";
		proxy_set_header Accept-Language "zh-CN";
	}

	# location /ray {   #分流路径
		# proxy_redirect off;
		# proxy_pass http://127.0.0.1:10000; #Xray端口
		# proxy_http_version 1.1;
		# proxy_set_header Upgrade \$http_upgrade;
		# proxy_set_header Connection "upgrade";
		# proxy_set_header Host \$host;
		# proxy_set_header X-Real-IP \$remote_addr;
		# proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
	# }
	
	location /xui {   #xui路径
		proxy_redirect off;
		proxy_pass http://127.0.0.1:54321;  #xui监听端口
		proxy_http_version 1.1;
		proxy_set_header Host \$host;
	}
}

server {
	listen 80;
	location /.well-known/ {
		   root /var/www/html;
		}
	location / {
			rewrite ^(.*)\$ https://\$host\$1 permanent;
		}
}
EOF

# 安装acme：
curl https://get.acme.sh | sh
# 添加软链接：
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
# 切换CA机构： 
acme.sh --set-default-ca --server letsencrypt
# 申请证书(dns 可以申请泛域名证书)： 
acme.sh  --issue --dns dns_cf -d ${DOMAINNAMW} -d *.${DOMAINNAMW} -k ec-256
# 安装证书：
acme.sh --install-cert -d ${DOMAINNAMW} --ecc --key-file ${CERTPATH}/${DOMAINNAMW}.key  --fullchain-file ${CERTPATH}/${DOMAINNAMW}.crt --reloadcmd "systemctl force-reload nginx"

# 安装Docker
# curl -sSL https://get.docker.com/ | sh

