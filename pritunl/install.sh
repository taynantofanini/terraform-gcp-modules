#!/bin/bash

# author: Taynan Tofanini <taynan@santodigital.com.br>
# describe:Install open source Pritunl VPN server on Ubuntu 20.04 LTS 
# version: 0.1
# license: MIT License

sudo apt update && sudo apt upgrade -y

sudo apt-get install curl gnupg2 wget unzip -y
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
sudo -s
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install mongodb-server -y
sudo systemctl start mongodb
sudo systemctl enable mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv E162F504A20CDF15827F718D4B7C549A058F8B6B
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
echo "deb http://repo.pritunl.com/stable/apt focal main" | tee /etc/apt/sources.list.d/pritunl.list
apt-get update
apt-get install pritunl -y
sudo systemctl start pritunl
sudo systemctl enable pritunl
sudo pritunl setup-key
pritunl default-password
