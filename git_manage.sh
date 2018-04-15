#!/bin/bash

ct="$(date +'%Y-%m-%d-%H:%M:%S')"

# Management
git add .
git commit -m $ct
git push

# Confirm file of update commit
echo $ct >> com_update
