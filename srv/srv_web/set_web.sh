#!/bin/bash

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
