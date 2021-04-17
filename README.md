# Cloudflare Warp
CloudflareWarp 一键脚本

![Warp](https://cdn.luotianyi.vc/wp-content/uploads/2021-02-04_21-05-50.jpg)

## 已知问题
Debian10下部分内核下 linux-headers 无法通过 `apt-get install linux-headers-`uname -r` -y` 完成安装 


## 手动安装版本教程：
[原帖](https://luotianyi.vc/5252.html)

## Warp 优点
- [x] Warp为没有IPV4的IPV6 Only的服务器增加IPV4
- [x] Warp为没有IPV6的IPV4 Only的服务器增加IPV6
- [x] Warp为拥有IPV4和IPV6隐藏真实的IPV4和IPV6
- [x] Warp可以提供流媒体解锁服务（包括YouTube、Netflix等）
- [x] Warp是完全免费的

## 本脚本的功能
- [x] 一键安装Warp
- [x] 支持没有IPV4的机器
- [x] 支持没有IPV6的机器
- [x] 三种模式：增加IPV4、增加IPV6、双栈

## 要求 
支持 `Ubuntu` `Debian` `CentOS7` (CentOS内核必须 >= 5.4) 

已测试`CentOS7`、`Ubuntu18`、`Debian9`、`Debian10`可以成功运行

建议使用一下脚本升级你的内核为BBR最新版本
```shell
wget stern.codes/tcpx.sh && bash tcpx.sh
```
选择1安装原版BBR，安装完之后`reboot`，开机之后执行`bash tcpx.sh`，输入11启动BBR加速

## 使用
Github链接（必须拥有IPV4，IPV6不支持）
```shell
wget https://raw.githubusercontent.com/missuo/CloudflareWarp/main/warp.sh && bash warp.sh
```

CDN链接(包含IPV4和IPV6)
```shell
wget stern.codes/warp.sh && bash warp.sh
```

## 测试
IPV4 & IPV6测试
```shell
curl ipv4.ip.sb
```
```shell
curl ipv6.ip.sb
```

流媒体测试（感谢 [Leo](https://github.com/sjlleo/)提供的流媒体测试脚本） 

Netflix
```shell
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.60_linux_amd64 && chmod +x nf && clear && ./nf
```
YouTube
```shell
wget -O tubecheck https://cdn.jsdelivr.net/gh/sjlleo/TubeCheck/CDN/tubecheck_1.0beta_linux_amd64 && chmod +x tubecheck && clear && ./tubecheck
```


## 反馈
欢迎测试，并且在ISSUES中提出BUG，我会在第一时间修复
