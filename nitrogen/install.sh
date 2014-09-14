#!/usr/bin/env sh 
#
#

# Update/upgrade
sudo apt-get update
sudo apt-get upgrade

# Get linux packages needed for Nitrogen
sudo apt-get install -yyq git emacs build-essential mongodb-server redis-server

# Manage node installation on ubuntu
sudo apt-get --purge remove node nodejs
sudo apt-get install -yyq nodejs
sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
sudo apt-get install -yyq npm

# Get Nitrogen - this is a repo of submodules to make life easier
sudo git clone https://github.com/irjudson/nitrogen.git
cd nitrogen
sudo git submodule init 
sudo git submodule update 

# Start the service
cd service
sudo npm install
cp /vagrant/nitrogen-service.conf /etc/init/nitrogen-service.conf
start nitrogen-service

# Start the admin app 
cd ../admin
npm install -g yo grunt-cli bower
npm install
bower install

cp /vagrant/nitrogen-admin.conf /etc/init/nitrogen-admin.conf

# Modify the code for now so we get good defaults
cat app/scripts/app.js | sed -e s%\/\/host\:%host\:% | sed -e s%\/\/http_port:%http_port:% | sed -e s%\/\/protocol:%protocol:% | sed -e s%force_https:\ true%force_https:\ false% > /tmp/app.js
cp /tmp/app.js app/scripts/app.js

start nitrogen-admin