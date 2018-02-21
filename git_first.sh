#!/bin/bash

# Make current directory local repository
git init
git add .
git commit -m "first commit!"

# Push remote repository
git remote add origin https://github.com/key36ra/$(basename $(pwd))
git push origin master

#
