#!/bin/bash

# Make user to be administrator
user=kimkim
echo $user" ALL=(ALL) ALL" >> /etc/sudoers

# To make a path
com_path=/sbin
echo PATH="$PATH"$com_path
