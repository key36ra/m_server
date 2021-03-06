#!/bin/bash

function func_ntp(){
	# NTP server
	yum -y install ntp
	echo "server -4 ntp.nict.jp" >> /etc/ntp.conf
	echo "server -4 ntp.jst.mfeed.ad.jp" >> /etc/ntp.conf
	ntpdate ntp.nict.jp # adjust time server at first
	systemctl start ntpd # start ntp server at centos7
	#/etc/rc.d/init.d/ntpd start # start ntp server at centos6
	systemctl enable ntpd # auto start ntp at centos7
	#chkconfig ntpd on # auto start ntp at centos6
}

function util_ntp(){
    # Confirm syncronization with foreign ntp server
    ntpq -p

	# Backup now timezone
	cp /etc/localtime /etc/localtime.bak
	# Change timezone from UST to JST(Japan)
	cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
}