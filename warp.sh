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


get_char(){
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

	echo "---------------------------------------------"
	echo
	echo -e "${green}Cloudflare Warp 一键脚本 Made by Vincent${plain}"
	echo
	echo -e "${red}支持Debian任意系列和CentOS Kernel >= 5.4${plain}"
	echo
	echo -e "${red}请先使用 uname -r 检查你的内核版本${plain}"
	echo "---------------------------------------------"
	echo
	echo "按任意键继续，或者按Control + C 退出"
	char=`get_char`
	cd ${cur_dir}

# 注册CF账号和获取配置文件
	echo -e "开始下载必要文件"
	wget -O wgcf https://stern.codes/wgcf_2.1.4_linux_amd64
	chmod +x wgcf
	echo "开始注册WGCF"
	./wgcf register
	./wgcf generate
	echo "已完成注册，即将执行下一步操作"

# 选择启动模式
	echo "------------------------------------------"
	echo
	echo "1: 为VPS增加Warp IPV6"
	echo
	echo "2: 为VPS增加Warp IPV4"
	echo
	echo "3: 为VPS增加Warp IPV4和IPV6"
	echo
	echo "------------------------------------------"
	read -p "请选择你需要启动的模式" start_type
	case $start_type in
	1)
		clear
		echo
		echo "你选择了增加IPV6的模式"
		echo
			
		echo "开始为该模式配置"
		echo
		sed -i '/AllowedIPs = 0.0.0.0/d'  wgcf-profile.conf
		sed -i 's/'engage.cloudflareclient.com'/'162.159.192.1'/g' wgcf-profile.conf
		echo
		echo "修改配置完成"
		echo
		echo "开始安装WireGuard"
		echo 
		yum install kmod-wireguard wireguard-tools -y
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
		echo "Made by Vincent"
		echo
		echo "Telegram: https://t.me/missuo"
		;;
	2)
		clear
		echo
		echo "你选择了增加IPV4的模式"
		echo
			
		echo "开始为该模式配置"
		echo
		sed -i '/AllowedIPs = ::/d'  wgcf-profile.conf
		sed -i 's/'engage.cloudflareclient.com'/'[2606:4700:d0::a29f:c001]'/g' wgcf-profile.conf
		echo
		echo "修改配置完成"
		echo
		echo "开始安装WireGuard"
		echo 
		yum install kmod-wireguard wireguard-tools -y
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
		echo "Made by Vincent"
		echo
		echo "Telegram: https://t.me/missuo"
		;;
	3)
		clear
		echo
		echo "你选择了增加IPV4和IPV6的模式"
		echo
			
		echo "开始为该模式配置"
		echo
		sed -i 's/'engage.cloudflareclient.com'/'162.159.192.1'/g' wgcf-profile.conf
		echo
		echo "修改配置完成"
		echo
		echo "开始安装WireGuard"
		echo 
		yum install kmod-wireguard wireguard-tools -y
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
		echo "Made by Vincent"
		echo
		echo "Telegram: https://t.me/missuo"
		;;

	*)
		echo "输入错误，请重新输入！"
		;;
	esac

	