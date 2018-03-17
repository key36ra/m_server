#!/bin/bash

function func_proxy(){
	# Proxy config
	PROXY="proxy.uec.ac.jp"
	git config --global http.proxy http://$PROXY:8080
	git config --global https.proxy http://$PROXY:8080
}

function func_unproxy(){
	# Delete proxy config
	git config --unset http.proxy
	git config --unset https.proxy
}

function func_clone(){
	# Clone remote repository
	REPO=m_GR
	git clone https://github.com/key36ra/$REPO
}

function func_mail(){
	EMAIL="kimdoubt96@gmail.com"
	USER="key36ra"
	git config --global user.email $EMAIL
	git config --global user.name $USER
}

function main(){
	#func_proxy
	#func_clone
	func_mail
}

main
