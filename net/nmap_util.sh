#!/bin/bash

function ping_scan(){
	# This "PingScan" shows the existing hosts in the network
	host_start=192.168.0.0
	host_range=10
	nmap -sP ${host_start}-${host_range}
}

function tcp_fullconnect_scan(){
	# This "TCP FullConnection Scan" shows the port and
	# service of the target host
	target_host=localhost
	nmap -sT $target_host # not need "-sT" option
}

function os_detection(){
	# This "OS Detection" shows the os of target host
	# This command requires root privilages
	target_host=localhost
	nmap -O $target_host
}
