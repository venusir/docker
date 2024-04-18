#!/bin/bash
host_to_ping="youtube.com"

# 备份配置文件
cp /etc/clash/config.yaml /etc/clash/config.yaml.bak
cp /etc/clash/Country.mmdb /etc/clash/Country.mmdb.bak
# 下载文件
wget -O /tmp/config.yaml 'https://wobushitishen.xyz/api/v1/client/subscribe?token=59513ba385a5c9de6a5682ba905ab62a&flag=clash'
wget -O /tmp/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
ConfigFlag=true
CountryFlag=true
if [ $ConfigFlag == true ]; then
	if [ -e /tmp/config.yaml ]; then
		if [ -s /tmp/config.yaml ]; then
			echo "下载成功"
		else
			echo "下载失败"
			ConfigFlag=false
		fi
	else
		echo "不存在"
		ConfigFlag=false
	fi
else
	wget -O /tmp/config.yaml 'https://wobushitishen.xyz/api/v1/client/subscribe?token=59513ba385a5c9de6a5682ba905ab62a&flag=clash'
fi

if [ $CountryFlag == true ]; then
	if [ -e /tmp/config.yaml ]; then
		if [ -s /tmp/config.yaml ]; then
			echo "下载成功"
		else
			echo "下载失败"
			CountryFlag=false
		fi
	else
		echo "不存在"
		CountryFlag=false
	fi
else
	wget -O /tmp/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
fi

if [ $ConfigFlag == true ] && [ $CountryFlag == true ];then
	row=$(grep -n "proxies" /tmp/config.yaml | head -1 | cut -d ":" -f 1)
	row=$[row-1]
	sed -i "1,${row}d" /tmp/config.yaml

	systemctl stop clash.service

	rm -rf /etc/clash/config.yaml
	rm -rf /etc/clash/Country.mmdb
	cat /etc/clash/template.yaml /tmp/config.yaml > /etc/clash/config.yaml
	mv /tmp/Country.mmdb /etc/clash/Country.mmdb

	systemctl start clash.service
	sleep 3
	if ping -c 1 "$host_to_ping" > /dev/null 2>&1; then
		echo "更新配置成功"
		rm -rf /etc/clash/config.yaml.bak
		rm -rf /etc/clash/Country.mmdb.bak
		rm -rf /tmp/config.yaml
	else
		echo "启动失败,现在回退上一轮配置,并所使用文件保留在/tmp/clash目录"
		mv /etc/clash/Country.mmdb /tmp/clash/Country.mmdb.error
		mv /etc/clash/config.yaml /tmp/clash/OverWriteConfig.yaml.error
		mv /tmp/config.yaml /tmp/clash/ProxiesConfig.yaml
		mv /etc/clash/config.yaml.bak /etc/clash/config.yaml  
		mv /etc/clash/Country.mmdb.bak /etc/clash/Country.mmdb
		systemctl restart clash.service
	fi
else
	echo "文件都下载失败了你更新个鸡儿"
	rm -rf /etc/clash/config.yaml.bak
	rm -rf /etc/clash/Country.mmdb.bak
fi