#!/usr/bin/python

import textfsm
import pprint
import mysql.connector
from netaddr import *

conn = mysql.connector.connect(
	host='127.0.0.1'
	port=3306
