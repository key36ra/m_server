#!/bin/bash

function func_os_set(){
	# Variable
	dir=rasp_os
	sd=/dev/mmcblk0 # not partition but device
	os=CentOS-Userland-7-armv7hl-Minimal-1708-RaspberryPi3.img
	# Make working directory
	mkdir $dir
	cd $dir
	# Write image to sd
	wget http://buildlogs.centos.org/centos/7/isos/armhfp/$os.xz # download image
	xz -d $os.xz # resolve compressed image
	sudo dd bs=8192 if=$os of=$sd # write image to sd
	# Delete working directory
	cd ../
	rm -r $dir
}

function func_setting(){
	sd=/dev/mmcblk0
	start=1000M
	end=28G
	#uuid=
	#pass=
	
	# Keyboard setting
	localectl set-keymap jp106
	localectl set-keymap jp-OADG109A
	
	# Expand the root partition
	parted $sd # into parted interface at sd
	rm 3
	mkpart primary $start $end
	quit
	reboot
	resize2fs ${sd}p3
	
	# Wifi setting
	#nmcli d # confirm the network connection
	#nmcli d wifi # confirm the wifi accesspoint
	#nmcli d wifi connect $uuid password $pass
	#nmcli d show wlan0 # confirm own ip by wlan0
	
	# Package db update
	yum update
	
	# User and Pass setting
	passwd root
	m_user=centm_ser0
	useradd $m_user
	passwd $m_user
	usermod ^G wheel $m_user # add user to Manager
	# only Manager ==> root
	
}

function func_pack(){
	yum -y install nmap # nmap
	yum -y install bind-utils # nslookup, dig ...
}

function func_net(){
	# Fix private ip
	#NIC=
	echo "IPADDR=192.168.0.2" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
	echo "PREFIX=24" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
	echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
	echo "DNS1=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
	echo "DNS2=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
}

function func_manage(){
	# Power supply
	poweroff # Shutdown os
	reboot # Reboot
}
