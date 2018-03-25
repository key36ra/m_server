#!/bin/bash

function func_iptables(){
	# Initialize the config of "NAT" and "FILTER"
	iptables -t filter -F INPUT
	iptables -t filter -F OUTPUT
	iptables -t filter -F FORWARD
	iptables -t nat -F PREROUTING
	iptables -t nat -F POSTROUTING
	iptables -t nat -F OUTPUT
}

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
	ntpq -p # confirm syncronization with ntp server
}

function func_dns(){
	# DiCE(DDNS client) install
	wget -O junkfile http://www.hi-ho.ne.jp/cgi-bin/user/yoshihiro_e/download.cgi?p=diced019
	tar zxfv junkfile
	mv DiCE /usr/local/bin
	rm junkfile
	# DiCE setting
}

function func_web(){
	# Binary Package
	#yum -y install httpd php php-mbstrings
	
	# OpenSSL
	yum -y install zlib-devel
	yum -y install perl-core
	wget https://www.openssl.org/source/openssl-1.1.1-pre2.tar.gz
	tar zxfv openssl*
	cd openssl*
	./config --prefix=/usr/local --openssldir=/usr/local/openssl
	make
	make install
	echo /usr/local/lib >> /etc/ld.so.conf
	ldconfig -v
	
	# APR
	yum -y install gcc
	cd /usr/local/src
	wget http://mirrors.ocf.berkeley.edu/apache//apr/apr-1.6.3.tar.gz
	tar xvzf apr-1.6.3.tar.gz
	cd apr-1.6.3
	./configure
	make
	make install
	
	# APR-util
	cd /usr/local/src
	wget http://mirrors.ocf.berkeley.edu/apache//apr/apr-util-1.6.1.tar.gz
	tar xvzf apr-util-1.6.1.tar.gz
	cd apr-util-1.6.1
	#sudo yum install expat-devel
	./configure --with-apr=/usr/local/src/apr-1.6.3
	make
	make install
	
	# PCRE
	yum -y install gcc-c++
	cd /usr/local/src
	wget https://sourceforge.net/projects/pcre/files/pcre/8.39/pcre-8.39.tar.gz
	tar xvzf pcre-8.39.tar.gz
	cd pcre-8.39
	./configure
	make
	make install
	
	# Apache
	wget -O junk_apache http://www-us.apache.org/dist//httpd/httpd-2.4.29.tar.gz
	tar zxfv junk_apache
	rm junk_apache
	cd httpd*
	./configure --enable-rewrite=shared --enable-ssl=shared \
	--prefix=/opt/www --with-pcre=/usr/local/src/pcre-8.41/pcre-config \
	--with-ssl=/usr/local/openssl --with-apr=/usr/local/src/apr-1.6.3 \
	--with-apr-util=/usr/local/src/apr-util-1.6.1
	make
	make install
	
	# Setup own CA
	cd /usr/local/openssl
	cp misc/CA.* . # CA.sh or CA.pl
	./CA.* -newca # make private key
	chmod 600 /usr/local/openssl/demoCA/private/cakey.pem # hide private key from foreigner
	chmod 700 /usr/local/openssl/demoCA/private
	openssl x609 -in /usr/local/openssl/demoCA/cacert.pem -text # confirm 
	
	# SSL Server setup
	cd /root
	openssl genrsa -out server.key 1024 # make server private key
	openssl req -new -key server.key -out server.csr # make csr
	# delete contents of index.txt for fail to update database
	cp -p /usr/local/openssl/demoCA/index.txt{,.old}
	: > /usr/local/openssl/demoCA/index.txt
	# signature certificate by own ca
	openssl ca -out serverca.crt -in server.csr
	mkdir /opt/www/conf/ssl
	mv server.key serverca.crt /opt/www/conf/ssl
	echo "ServerName spinnenest.dip.jp:80" >> /opt/www/conf/httpd.conf
	echo "LoadModule ssl_module module/mod_ssl.so" >> /opt/www/conf/httpd.conf
	echo "Include conf/extra/httpd-ssl.conf" >> /opt/www/conf/httpd.conf
	echo "SSLCertificateKeyFile /opt/www/conf/ssl/server.key" >> /opt/www/conf/extra/httpd-ssl.conf
	echo "SSLCertificateFile /opt/www/conf/ssl/serverca.crt" >> /opt/www/conf/extra/httpd-ssl.conf
	echo "ServerName spinnenest.dip.jp:443" >> /opt/www/conf/extra/httpd-ssl.conf
	
	# Httpd
	#/opt/www/bin/apachectl -k start # stop, restart, or reload
	systemctl start httpd # make /usr/lib/systemd/system/httpd.service
	
	# Confirm connection if browser doesn't connect
	curl http://localhost # if this connect, confirm firewall 80 port
}

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

function func_db(){
	# DB operation user
	useradd mysql
	
	# Cmake
	cd /usr/local/src
	wget https://cmake.org/files/v3.11/cmake-3.11.0-rc4.tar.gz
	tar xzvf cmake*
	cd cmake*
	./configure
	gmake
	make install
	
	# ncurses
	cd /usr/local/src
	wget http://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
	tar xzvf ncurses*
	cd ncurses
	./configure --with-shared
	make
	make install
	
	# MariaDB
	cd /usr/local/src
	wget --trust-server-names https://downloads.mariadb.org/interstitial/mariadb-10.2.13/source/mariadb-10.2.13.tar.gz
	cd mariadb*
	BUILD/autorun.sh
	
	/usr/local/bin/cmake \
	-DPLUGIN_TOKUDB=NO \
	-OPENSSL_ROOT_DIR=/usr/local/openssl \
	-OPENSSL_INCLUDE_DIR=/usr/local/openssl/include \
	-OPENSSL_LIBRARIES=/usr/local/openssl/lib \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci
	make install
	
	chown mysql:mysql -R /usr/local/mysql/
	cp support-files/my-medium.cnf /etc/my.cnf
	su mysql
	cd /usr/local/mysql
	scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql \
	--datadir=/usr/local/mysql/data
	exit
}
	
