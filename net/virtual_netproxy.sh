#!/bin/bash

# Apply proxy url to config of all user
echo "export HTTP_PROXY=http://proxy.uec.ac.jp:8080" >> /etc/profile.d/proxy.sh
echo "export FTP_PROXY=http://proxy.uec.ac.jp:8080" >> /etc/profile.d/proxy.sh
chmod +x /etc/profile.d/proxy.sh
source /etc/profile.d/proxy.sh

# Otherwise, apply to own config
echo "export HTTP_PROXY=http://proxy.uec.ac.jp:8080" >> ~/.bashrc
echo "export FTP_PROXY=http://proxy.uec.ac.jp:8080" >> ~/.bashrc
source ~/.bashrc
