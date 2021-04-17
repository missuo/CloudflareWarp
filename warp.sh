#!/bin/bash

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Current folder
cur_dir=`pwd`
# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
# Make sure only root can run our script
[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] This script must be run as root!" && exit 1

# 判断系统版本
check_system(){
	if [[ -f /etc/redhat-release ]]; then
	release="centos"
	elif grep -Eqi "debian|raspbian" /etc/issue; then
		release="debian"
	elif grep -Eqi "ubuntu" /etc/issue; then
		release="ubuntu"
	elif grep -Eqi "centos|red hat|redhat" /etc/issue; then
		release="centos"
	elif grep -Eqi "debian|raspbian" /proc/version; then
		release="debian"
	elif grep -Eqi "ubuntu" /proc/version; then
		release="ubuntu"
	elif grep -Eqi "centos|red hat|redhat" /proc/version; then
		release="centos"
	fi

# 根据系统安装必要软件
	if [ $release = "centos" ]
	then
		yum install kmod-wireguard wireguard-tools -y
	elif [ $release = "debian" ]
	then
		apt-get install sudo net-tools openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get update
		sudo apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-dkms wireguard-tools -y
	elif [ $release = "ubuntu" ]
	then
		apt-get install sudo net-tools openresolv -y
		apt-get update
		apt-get install wireguard -y
	else
		echo "不支持该系统"
		exit 1
	fi
}

get_char(){
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

	echo "---------------------------------------------------------"
	echo
	echo -e "${green}Cloudflare Warp 一键脚本 Made by Vincent${plain}"
	echo
	echo -e "${red}支持Debian、Ubuntu、CentOS${plain}"
	echo
	echo -e "${red}请先使用 uname -r 检查你的内核版本${plain}"
	echo 
	echo "https://github.com/missuo/CloudflareWarp"
	echo 
	echo "---------------------------------------------------------"
	echo
	echo "按任意键继续，或者按Control + C 退出"
	char=`get_char`
	cd ${cur_dir}

# 注册CF账号和获取配置文件
	echo -e "开始下载必要文件"
	wget -O wgcf https://stern.codes/wgcf_2.1.4_linux_amd64
	chmod +x wgcf
	echo "开始注册Warp Account"
	./wgcf register
	./wgcf generate
	echo "已完成注册，即将执行下一步操作"
	echo

# 选择启动模式
	echo "------------------------------------------"
	echo
	echo "1: 增加Warp IPV6"
	echo
	echo "2: 增加Warp IPV4"
	echo
	echo "3: 增加Warp IPV4 & IPV6"
	echo
	echo "------------------------------------------"
	read -p "请选择你需要启动的模式: " start_type
	case $start_type in
	1)
		clear
		echo
		echo "你选择了增加IPV6的模式"
		echo
		echo "开始为该模式配置"
		sed -i '/AllowedIPs = 0.0.0.0/d'  wgcf-profile.conf
		sed -i 's/'engage.cloudflareclient.com'/'162.159.192.1'/g' wgcf-profile.conf
		echo
		echo "修改配置完成"
		echo
		echo "开始安装WireGuard"
		echo 
		
		check_system
		echo
		echo "安装完成，开始加载WireGuard内核模块"
		modprobe wireguard
		echo 
		cp wgcf-profile.conf /etc/wireguard/wgcf.conf
		echo "开启启动WireGuard隧道"
		echo
		sudo wg-quick up wgcf
		echo "WireGuard隧道启动完成"
		echo
		echo "开始检测本机IPV6"
		curl ipv6.ip.sb
		echo
		echo "恭喜你！配置完成！"
		echo
		echo "感谢使用!"
		echo
		;;
	2)
		clear
		echo
		echo "你选择了增加IPV4的模式"
		echo
		echo "开始为该模式配置"
		sed -i '/AllowedIPs = ::/d'  wgcf-profile.conf
		sed -i 's/'engage.cloudflareclient.com'/'[2606:4700:d0::a29f:c001]'/g' wgcf-profile.conf
		echo
		echo "修改配置完成"
		echo
		echo "开始安装WireGuard"
		echo 
		check_system
		echo 
		echo "安装完成，开始加载WireGuard内核模块"
		modprobe wireguard
		echo 
		cp wgcf-profile.conf /etc/wireguard/wgcf.conf
		echo "开启启动WireGuard隧道"
		echo
		sudo wg-quick up wgcf
		echo "WireGuard隧道启动完成"
		echo
		echo "开始检测本机IPV4"
		curl ipv4.ip.sb
		echo
		echo "恭喜你！配置完成！"
		echo
		echo "感谢使用!"
		echo
		;;
	3)
		clear
		echo
		echo "你选择了增加IPV4和IPV6的模式"
		echo
		echo "开始为该模式配置"
		sed -i 's/'engage.cloudflareclient.com'/'162.159.192.1'/g' wgcf-profile.conf
		echo
		echo "修改配置完成"
		echo
		echo "开始安装WireGuard"
		echo 
		check_system
		echo 
		echo "安装完成，开始加载WireGuard内核模块"
		modprobe wireguard
		echo 
		cp wgcf-profile.conf /etc/wireguard/wgcf.conf
		echo "开启启动WireGuard隧道"
		echo
		sudo wg-quick up wgcf
		echo "WireGuard隧道启动完成"
		echo
		echo "开始检测本机IPV4"
		curl ipv4.ip.sb
		echo
		echo "开始检测本机IPV6"
		curl ipv6.ip.sb
		echo
		echo "恭喜你！配置完成！"
		echo
		echo "感谢使用!"
		echo
		;;

	*)
		echo "输入错误，请重新输入！"
		;;
	esac

	
