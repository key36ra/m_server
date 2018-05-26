#!/usr/bin/env python3

import textfsm
import pprint
import mysql.connector
from netaddr import *

# Connet object to mysql
conn = mysql.connector.connect(
	host='127.0.0.1',
	port=3306,
	user='',
	passwd='',
	db='')

# Open the cursor
cur = conn.cursor()

# Read log file
with open('sample.log', 'r') as f:
	config = f.read()

# 
with open('template_tmp.txt', 'r') as f:
	table = textfsm.TextFSM(f)
	result = table.ParseText(config)

for row in result:
	(ipaddr, netmask) = row[3].split(" ")
	nw = IPNetwork(ipaddr)
	nw.prefixlen = IPAddress(netmask).netmask_bits()
	nw = nw.cidr
	host = row[0]
	vlan = row[1]
	sql = "INSERT INTO config_data (IP_ADDRESS, HOST, NETMASK, VLAN, NW_ADDRESS) values (%s,%s,%s,%s,%s)"
	cur.execute(sql,(str(ipaddr), host, str(netmask), vlan, str(nw)))
	conn.commit()
	print(row)

cur.close()
conn.close()
