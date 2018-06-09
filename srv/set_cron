#!/bin/bash

function set_cron(){
	systemctl start crond
	systemctl enable crond
	
	# Confirm schedule
	crontab -l
	
	# Edit cron.tab and reflect it to crontab
	crontab < cron.tab
}
