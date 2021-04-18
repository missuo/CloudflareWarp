#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#================================================================
#	System Required: CentOS 6/7/8,Debian 8/9/10,Ubuntu 16/18/19
#	Kernel Required: 5.X
#	Description: Cloudflare One-Step Script
#	Version: 2.0
#	Author: Vincent Young
# 	Telegram: https://t.me/missuo
#	Github: https://github.com/missuo/CloudflareWarp
#=================================================================

#获取键盘输入
get_char(){
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

#定义一些颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

#确保本脚本在ROOT下运行
[[ $EUID -ne 0 ]] && echo -e "[${red}错误${plain}]请以ROOT运行本脚本！" && exit 1

#检查系统信息
check_sys(){
	echo "现在开始检查你的系统是否支持"
	#判断是什么Linux系统
	if [[ -f /etc/redhat-release ]]; then
		release="Centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
    fi
	
	#判断Linux系统的具体版本和位数
	if [[ -s /etc/redhat-release ]]; then
		version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
	else
		version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="x64"
	else
		bit="x32"
	fi
	
	#判断内核版本
	kernel_version=`uname -r | awk -F "-" '{print $1}'`
	kernel_version_full=`uname -r`
	net_congestion_control=`cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}'`
	net_qdisc=`cat /proc/sys/net/core/default_qdisc | awk '{print $1}'`
	kernel_version_r=`uname -r | awk '{print $1}'`
	echo "系统版本为: $release $version $bit 内核版本为: $kernel_version_r"
	#判断内核版本是否支持
	if [[ `echo ${kernel_version} | awk -F'.' '{print $1}'` == "5" ]]; then
		echo "检查通过 该系统支持安装Cloudflare Warp"
	else
		echo "[${red}错误${plain}]抱歉 你的系统不支持安装Cloudflare Warp 请先升级内核版本到5.X后重试"
		exit 1
	fi

	#根据系统类型安装WireGuard
	if [ $release = "Centos" ]
	then
		yum install kmod-wireguard wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		sudo apt-get update
		sudo apt-get install sudo net-tools openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		sudo apt-get install linux-headers-`uname -r` -y
		sudo apt-get install wireguard-dkms wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		sudo apt-get update
		sudo apt-get install sudo net-tools openresolv -y
		sudo apt-get install wireguard -y
	else
		echo "[${red}错误${plain}]不支持当前系统"
		exit 1
	fi
}
check_sys

reg_account(){
	echo "开始注册Cloudflare Warp账号"
	wget -O wgcf https://stern.codes/wgcf_2.1.4_linux_amd64
	chmod +x wgcf
	./wgcf register
	./wgcf generate
	echo "已完成注册 即将执行下一步操作"
}

add_ipv4(){
	reg_account
	echo -e "
	你确定要继续吗？
	该模式会导致原IPV4建立的SSH连接断开" && echo
	echo "按任意键继续，或者按Control + C 退出"
	char=`get_char`
	clear
	echo "你选择了增加 IPV4 的模式"
	echo "开始自动修改配置文件"
	sed -i '/AllowedIPs = ::/d'  wgcf-profile.conf
	sed -i 's/'engage.cloudflareclient.com'/'[2606:4700:d0::a29f:c001]'/g' wgcf-profile.conf
	echo "开始加载WireGuard内核模块"
	modprobe wireguard
	cp wgcf-profile.conf /etc/wireguard/wgcf.conf
	echo "开启启动WireGuard隧道"
	sudo wg-quick up wgcf
	echo "WireGuard隧道启动完成"
	echo "开始检测本机IPV4"
	IP=$(curl -s ipv4.ip.sb)
	if [ ! -n $IP ]; then
		echo "IPV4检测失败"
	else
		clear
		echo
		echo "本机IPV4: $IP"
	fi
	echo
	echo "恭喜你！配置完成！感谢使用! Have a nice day :)"
	echo
}

add_ipv6(){
	reg_account
	clear
	echo "你选择了增加 IPV6 的模式"
	echo "开始自动修改配置文件"
	sed -i '/AllowedIPs = 0.0.0.0/d'  wgcf-profile.conf
	sed -i 's/'engage.cloudflareclient.com'/'162.159.192.1'/g' wgcf-profile.conf
	echo "开始加载WireGuard内核模块"
	modprobe wireguard
	cp wgcf-profile.conf /etc/wireguard/wgcf.conf
	echo "开启启动WireGuard隧道"
	sudo wg-quick up wgcf
	echo "WireGuard隧道启动完成"
	echo "开始检测本机IPV6"
	IP=$(curl -s ipv6.ip.sb)
	if [ ! -n $IP ]; then
		echo "IPV6检测失败"
	else
		clear
		echo
		echo "本机IPV6: $IP"
	fi
	echo
	echo "恭喜你！配置完成！感谢使用! Have a nice day :)"
	echo
}

add_both(){
	reg_account
	echo -e "
	你确定要继续吗？
	该模式会导致原IPV4建立的SSH连接断开" && echo
	echo "按任意键继续，或者按Control + C 退出"
	char=`get_char`
	clear
	echo "你选择了增加 IPV4 & IPV6 的双栈模式"
	echo "开始自动修改配置文件"
	sed -i 's/'engage.cloudflareclient.com'/'162.159.192.1'/g' wgcf-profile.conf
	echo "开始加载WireGuard内核模块"
	modprobe wireguard
	cp wgcf-profile.conf /etc/wireguard/wgcf.conf
	echo "开启启动WireGuard隧道"
	sudo wg-quick up wgcf
	echo "WireGuard隧道启动完成"
	echo "开始检测本机IPV4"
	echo
	IP=$(curl -s ipv4.ip.sb)
	if [ ! -n $IP ]; then
		echo "IPV4检测失败"
	else
		echo "本机IPV4: $IP"
	fi
	echo "开始检测本机IPV6"
	IP=$(curl -s ipv6.ip.sb)
	if [ ! -n $IP ]; then
		echo "IPV6检测失败"
	else
		echo "本机IPV6: $IP"
	fi
	echo
	echo "恭喜你！配置完成！感谢使用! Have a nice day :)"
	echo
}

start_menu(){
	clear
	echo && echo -e "Cloudflare Warp 一键安装脚本 Made by missuo
更新内容及反馈： https://github.com/missuo/CloudflareWarp
————————————模式选择————————————
${green}1.${plain} 仅增加IPV4 [推荐]
${green}2.${plain} 仅增加IPV6 [推荐]
${green}3.${plain} 同时增加IPV4 & IPV6[慎用]
${green}0.${plain} 退出脚本
————————————————————————————————"
	read -p " 请输入数字: " num
	case "$num" in
	1)
	add_ipv4
	;;
	2)
	add_ipv6
	;;
	3)
	add-both
	;;
	0)
	exit 1
	;;
	*)
	clear
	echo -e "[${red}错误${plain}]:请输入正确数字[0-3]"
	sleep 5s
	start_menu
	;;
esac
}
start_menu



