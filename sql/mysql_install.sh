#!/bin/bash


function func_ins(){
	sudo apt install mysql-server # install mysql-server
	mysql_secure_installation # security config
}

OPTIONS='-u root -p'

function func_user(){
	user='test'
	host='localhost'
	pass='password'
	
	sql_user="
	create user $user@$host IDENTIFIED BY $pass;
	"
	
	echo "$sql_user" | mysql $OPTIONS
}

function func_pass(){
	user='test'
	host='localhost'
	pass='password'
	
	sql_pass="
	set password for $user@$host = password($pass);
	"
	
	echo "$sql_pass" | mysql $OPTIONS
}
