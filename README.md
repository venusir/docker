## 第三方工具脚本

* 一键切换国内源
```
bash <(curl -fsSL https://linuxmirrors.cn/main.sh)
```

* 一键安装Docker
```
bash <(curl -fsSL https://linuxmirrors.cn/docker.sh)
```

### Linux设置git代理github

```
#设置全局代理
#http
git config --global https.proxy http://127.0.0.1:1080
#https
git config --global https.proxy https://127.0.0.1:1080

#使用socks5代理的 例如ss，ssr 1080是windows下ss的默认代理端口,mac下不同，或者有自定义的，根据自己的改
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

#只对github.com使用代理，其他仓库不走代理
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
git config --global https.https://github.com.proxy socks5://127.0.0.1:1080

#取消仅对https://github.com设置的代理
git config --global --unset http.https://github.com.proxy
git config --global --unset https.https://github.com.proxy

#取消git对所有网站的代理
git config --global --unset http.proxy
git config --global --unset https.proxy

#查看代理
git config --global --get http.proxy
git config --global --get https.proxy

```
