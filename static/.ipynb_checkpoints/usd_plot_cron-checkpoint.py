#!/usr/bin/env python3

"""
This sample code is to plot figure to png file at shell.
"""

# Time control
#from datetime import datetime
# DataFrame
import pandas as pd
# Plot figure module
import matplotlib
matplotlib.use('Agg') # For no display environmental value
import matplotlib.pyplot as plt

file_name = '/home/centm_ser0/m_server/static/usd.csv'

def main():
	df = pd.read_csv(file_name)
	df['day-time'] = df['day'].astype(str) + '-' + df['hour'].astype(str) + ':' + df['minute'].astype(str)
	
	df.plot(x='day-time',y='usd')
	plt.title('USDJPY')
	plt.xlabel('day-hour:minute')
	plt.ylabel('usd/yen')
	
	plt.savefig('/opt/www/htdocs/usd_plot.png')
	
	#print(datetime.now().strftime("%Y/%m/%d-%H:%M:%S"))

main()
