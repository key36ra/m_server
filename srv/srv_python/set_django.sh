#!/bin/bash

function install_django(){
	# Install django
	pip install django
	
	# Start project
	django-admin startproject mysite
	cd mysite
	
	# Run server for development
	python manage.py runserver 0:8000
	
	# make application
	python manage.py startapp polls	
}

function database(){
	# MariaDB create user
	user='m_site0'
	host='localhost'
	pass=''
	make_user="CREATE USER $user@$host identified by $pass;"
	echo $make_user | mysql -u root
	
	# MariaDB create database
	db='m_site0'
	make_db="CREATE DATABASE m_site0"
	echo $make_db | mysql -u root
	
	# Grant db privileges to user
	grant_db="GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, DROP on $db.* to $user@$host;"
	echo $grant_db | mysql -u root
	
	# Drop table from db
	key='fuga*'
	mysql -u root -e 'SHOW TABLES FROM $db'| grep $key | xargs -I "@@" mysql -u root -e "DROP TABLE $db.\`@@\`"
}
