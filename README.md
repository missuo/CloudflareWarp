# Cloudflare Warp
CloudflareWarp 一键脚本

![Warp](https://cdn.luotianyi.vc/wp-content/uploads/2021-02-04_21-05-50.jpg)

## 更新
### 2021年6月13日
- [x] 加入了开机自启
- [x] 彻底修复了 `Debian 10` 第一次安装可能不成功的问题
- [x] 移除了双栈无损模式 
- [x] 加入了流媒体检测

### 2021年5月31日
- [x] 增加了ARM 64的支持

### 2021年5月21日
- [x] 改进了在注册Warp账号的时候需要手动回车选择`Yes`的问题 
- [x] 修复了没有`wget`、`curl`可能导致安装失败的问问题 
- [x] 增加了`IPv4&IPv6的无损模式`，仅出站走Warp「仅支持`Ubuntu 20.04`」

### 感谢Bug发现的小伙伴
感谢 [2guan](https://github.com/2guan) 指出 可能安装失败的问题 

感谢 [lns103](https://github.com/lns103) 建议 无损双栈方案 

感谢 [tianyunb666](https://github.com/tianyunb666) 和 [ChellyL](https://github.com/ChellyL) 指出 `Debian 10` 安装失败的问题 

「如有疏漏，请谅解」

## 已知问题
`Debian10` 部分内核下 `linux-headers` 无法通过 `apt-get install linux-headers-$(uname -r)` 完成安装 
### 解决方案
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
reboot
sudo apt-get install linux-headers-$(uname -r) -y
```

## 参考文章：
[Luminous大佬](https://luotianyi.vc/5252.html) 

本脚本与 `Luminous` 无关

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
支持 `Ubuntu` `Debian` `CentOS7` (内核必须为 >= 5.X  4.X版本可能会导致`linux-headers`无法安装)

已测试`CentOS7`、`Ubuntu18`、`Debian9`、`Debian10`可以成功运行

建议使用一下脚本升级你的内核为BBR最新版本
```shell
wget uone.one/tcpx.sh && bash tcpx.sh
```
选择1安装原版BBR，安装完之后`reboot`，开机之后执行`bash tcpx.sh`，输入11启动BBR加速

## 使用
### Linux X86_64
```shell
wget -O warp.sh https://cdn.jsdelivr.net/gh/missuo/CloudflareWarp/warp.sh && bash warp.sh
```
### Linux ARM_64 (90%失败)
```shell
wget -O warp.sh https://cdn.jsdelivr.net/gh/missuo/CloudflareWarp/warp-arm64.sh && bash warp.sh
```

## 测试
IPV4 & IPV6测试
```shell
curl ipv4.ip.sb
```
```shell
curl ipv6.ip.sb
```

流媒体测试（感谢  [Leo](https://github.com/sjlleo/) 提供的流媒体测试脚本） 

Netflix
```shell
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.60_linux_amd64 && chmod +x nf && clear && ./nf
```
YouTube
```shell
wget -O tubecheck https://cdn.jsdelivr.net/gh/sjlleo/TubeCheck/CDN/tubecheck_1.0beta_linux_amd64 && chmod +x tubecheck && clear && ./tubecheck
```

## 关于开源
本脚本的所有代码可以随意拿去使用，但是希望注明来源。之前本脚本的 `Debian 10` 一次绝对安装不成功。希望之前参考了本脚本的开发者看到后能及时修改，以免影响使用。

## 反馈
欢迎测试，并且在ISSUES中提出BUG，我会在第一时间修复
