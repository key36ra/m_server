#!/bin/bash

if [ "$1" = "" ];then
	cat <<-EOS
	usage $0 [db name]
	EOS
	exit
fi

DB=$1 # m_lpic
OPTIONS="-u root -p" # or "--user=root --password="
pass="kimkim"

# Create databases and tables
function sql_variable(){
	SQL_dat="
	create database $DB;
	"
	
	SQL_tab="
	use $DB;
	CREATE TABLE m_tab (
		exam_id int(11),
		level varchar(100),
		cource_name varchar(200),
		exam_fee int(11)
	);
	"
	
	SQL_ins="
	use $DB
	INSERT INTO m_tab VALUES
		('0', 'level1', 'lpi101', '15000'),
		('1', 'level1', 'lpi102', '15000'),
		('2', 'level2', 'lpi201', '15000'),
		('3', 'level2', 'lpi202', '15000'),
		('4', 'level3', 'lpi300', '30000'),
		('5', 'level3', 'lpi303', '30000'),
		('6', 'level3', 'lpi304', '30000');
	SHOW tables;
	" # insert values must be covered by ''
	
	#echo "$SQL_dat" | mysql $OPTIONS$pass
	#echo "$SQL_tab" | mysql $OPTIONS$pass
	echo "$SQL_ins" | mysql $OPTIONS$pass
}

sql_variable
