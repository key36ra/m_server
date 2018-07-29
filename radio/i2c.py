#!/usr/bin/env python3

import smbus2 as smbus

bus = smbus.SMBus(1)
addr_lcd = 0x3f
s = "abcde"

bus.write_i2c_block_data(addr_lcd, ord(s[0]), ord(s[1:]))
