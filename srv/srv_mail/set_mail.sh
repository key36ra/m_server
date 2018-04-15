#!/bin/bash

function func_mail(){
	# Download postfix
	cd /usr/local/src
	wget ftp://ftp.riken.jp/net/postfix/postfix-release/official/postfix-3.3.0.tar.gz
	tar xvzf postfix*
	cd postfix*
	
	# User and Group
	groupadd postfix
	groupadd postdrop
	#cat /etc/group # confirm exist group
	adduser -g postfix -d /var/spool/postfix \
	-s /sbin/nologin -c "Postfix User" postfix
	#cat /etc/passwd # confirm exist user
	
	# Install
	make tidy
	make
	make install
}
