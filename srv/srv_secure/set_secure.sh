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

function main(){
	func_iptables;
}

main;
