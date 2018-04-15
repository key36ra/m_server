#!/bin/bash

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
	# Compile + Install
	/usr/local/bin/cmake \
	-DPLUGIN_TOKUDB=NO \
	-OPENSSL_ROOT_DIR=/usr/local/openssl \
	-OPENSSL_INCLUDE_DIR=/usr/local/openssl/include \
	-OPENSSL_LIBRARIES=/usr/local/openssl/lib \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci
	make install
	# 
	chown mysql:mysql -R /usr/local/mysql/
	#cp support-files/my-medium.cnf /etc/my.cnf
	cp my.cnf /etc/my.cnf
	su mysql
	cd /usr/local/mysql
	scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql \
	--datadir=/usr/local/mysql/data
	exit
	# Config file
	cp mariadb.service /usr/lib/systemd/system/
	cp mariadb-wait-ready mariadb-prepare-db-dir \
	mysql_install_db /usr/libexec/
	# Grant
	chmod +x /usr/libexec/mariadb-wait-ready
	chmod +x /usr/libexec/mariadb-prepare-db-dir
	chmod +x /usr/libexec/mysql_install_db
	# Directory for Process
	mkdir -p /run/mysql
	chown mysql:mysql /run/mysql
	# System set
	systemctl start mariadb
	systemctl enable mariadb
	# Set include file
	mv /usr/local/mysql/include /usr/local/mysql/include.def
	mkdir -p /usr/local/mysql/include/mysql
	chown -R mysql:mysql /usr/local/mysql/include
	cd /usr/local/src/mariadb*/include
	cp -rf ./* /usr/local/mysql/include/mysql
}
