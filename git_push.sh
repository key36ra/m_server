#!/bin/bash

ct="$(date +'%Y-%m-%d-%H:%M:%S')"

# Confirm file of update commit
echo -e "\n$ct" >> update_confirm

# Management
git add .
git commit -m $ct
git push
