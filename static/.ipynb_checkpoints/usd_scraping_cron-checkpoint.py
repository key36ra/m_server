#!/usr/bin/env python3

"""
Get USD/yen value per a minute
"""

import urllib.request
from bs4 import BeautifulSoup
from datetime import datetime
import os

# Ignore SSL_CERTIFICATE for https
import ssl
ssl._create_default_https_context = ssl._create_unverified_context

# Yahoo finance
url = "https://stocks.finance.yahoo.co.jp/stocks/detail/?code=USDJPY=X&serviceKanriId=USDJPY=X&pos=1&ccode=ofv"
# Data file
file_name = '/home/centm_ser0/m_server/static/usd.csv'

# Make data elements for first execution
if os.path.exists(file_name):
	pass
else:
	element = "year,month,day,hour,minute,usd,\n"
	file = open(file_name, 'w')
	file.write(element)
	file.close()

def main():
	# Scraping
	response = urllib.request.urlopen(url)
	soup = BeautifulSoup(response, 'html.parser')
	# US doll rate
	td = soup.find("td", class_="stoksPrice")
	
	# Time to confirm this program successed
	now = datetime.now()
	#time_ = "This is {}".format(now.strftime("%Y/%m/%d-%H:%M:%S"))
	
	# Print US doll rate and confirmation
	#print(td.string)
	#print(time_)
	
	# Save usd to csv file
	file = open(file_name, 'a')
	file.write('{},{},\n'.format(now.strftime("%Y,%m,%d,%H,%M"),td.string))
	file.close()

main()
