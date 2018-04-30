#!/bin/bash

ct="$(date +'%Y-%m-%d-%H:%M:%S')"

# Confirm file of update commit
echo -e $ct >> update_confirm
echo -e "" >> update_confirm

# Management
git add .
git commit -m $ct
git push
