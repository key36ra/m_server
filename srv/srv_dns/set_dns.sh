#!/bin/bash

function func_dns(){
	# DiCE(DDNS client) install
	wget -O junkfile http://www.hi-ho.ne.jp/cgi-bin/user/yoshihiro_e/download.cgi?p=diced019
	tar zxfv junkfile
	mv DiCE /usr/local/bin
	rm junkfile
	# DiCE setting
}
