#!/usr/bin/python3 

import smbus2 as smbus 
import subprocess
import time

i2c = smbus.SMBus(1) # newer version RASP (512 megabytes) 
#bus = smbus.SMBus(0) # RASP older version (256MB) 

freq =  81.3 # desired frequency in MHz (at 101.1 popular music station in Melbourne) 

# Frequency distribution for two bytes (according to the data sheet) 
freq14bit = int(4 * (freq * 1000000 + 225000) / 32768) 
freqH = freq14bit>>8 #int (freq14bit / 256) 
freqL = freq14bit & 0xFF 

data = [0 for i in range(4)] # Descriptions of individual bits in a byte - viz.  catalog sheets 
add = 0x60 # I2C address circuit 
init = freqH # freqH # 1.bajt (MUTE bit; Frequency H)  // MUTE is 0x80
data[0] = freqL # 2.bajt (frequency L) 
data[1] = 0xB0 #0b10110000 # 3.bajt (SUD; SSL1, SSL2; HLSI, MS, MR, ML; SWP1) 
data[2] = 0x10 #0b00010000 # 4.bajt (SWP2; STBY, BL; XTAL; smut; HCC, SNC, SI) 
data[3] = 0x00 #0b00000000 # 5.bajt (PLREFF; DTC; 0; 0; 0; 0; 0; 0) 



#i2c.write_quick(add)
time.sleep(0.1)
print(i2c.read_byte(add))
try:
  print(add)
  i2c.write_i2c_block_data(add, init, data) # Setting a new frequency to the circuit 
except IOError:
  subprocess.call(['i2cdetect', '-y', '1'])
  flag = 1     #optional flag to signal your code to resend or something
else:
  print("can work")
