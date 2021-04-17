# Cloudflare Warp
CloudflareWarp 一键脚本

![Warp](https://cdn.luotianyi.vc/wp-content/uploads/2021-02-04_21-05-50.jpg)

## Warp 优点
- [x] Warp为没有IPV4的IPV6 Only的服务器增加IPV4
- [x] Warp为没有IPV6的IPV4 Only的服务器增加IPV6
- [x] Warp为拥有IPV4和IPV6隐藏真实的IPV4和IPV6
- [x] Warp为无法解锁流媒体的服务器提供流媒体解锁服务
- [x] Warp是完全免费的

## 本脚本的功能
- [x] 一键安装Warp
- [x] 支持没有IPV4的机器
- [x] 支持没有IPV6的机器
- [x] 三种模式：增加IPV4、增加IPV6、双栈

## 要求
支持Debian所有内核 

支持CentOS 7 Kernel>=5.4 （强烈推荐）

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
## 反馈
欢迎测试，并且在ISSUES中提出BUG，我会在第一时间修复
