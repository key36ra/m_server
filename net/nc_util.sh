#!/bin/bash

function tcp_client(){
	# connect to the target host at specific port
	target_host=localhost
	target_port=8888
	nc $target_host $target_port
}

function tcp_listen(){
	# listen the connect at specific port
	local_port=8888
	nc -l -p $local_port
}

function file-trans_recv(){
	# recv file as "file_name"
	local_port=8888
	file_name=doubt.txt
	nc -l -p $local_port > $file_name
}

function file-trans_send(){
	# transport "file_name" file to the target host
	target_host=localhost
	target_port=8888
	file_name=doubt.txt
	nc $target_host $target_port < $file_name
}

function bash_backdoor(){
	# This service redirect the command of client to bash
	# So, client can use bash in this com
	local_port=8888
	nc -l -p 8888 -e /bin/bash
}

function port_scan(){
	# Scan port of "target_host" between "p_start" and "p_end"
	target_host=localhost
	p_start=1
	p_end=1023
	nc -z -v $target_host $p_start-$p_end
}
