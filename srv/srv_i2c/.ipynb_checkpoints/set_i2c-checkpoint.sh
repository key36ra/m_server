#!/bin/bash

function install_i2c(){
    echo "dtparam=i2c_arm=on" >> /boot/config.txt
    echo "i2c-dev" >> /etc/modules
    yum install i2c-tools #python-smbus
    
    # Install python library for controlling i2c device
    pip install smbus2
}

function util_i2c(){
    # Confirm the detection of i2c device
    i2cdetect -y 1
}