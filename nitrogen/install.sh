#!/usr/bin/env sh 
#
#

# Update/upgrade
sudo apt-get update
sudo apt-get upgrade

# Get linux packages needed for Nitrogen
sudo apt-get install -yyq git emacs build-essential mongodb-server redis-server ruby1.9.1-dev libffi-dev

# Manage node installation on ubuntu
sudo apt-get --purge remove node nodejs
sudo apt-get install -yyq nodejs
sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
sudo apt-get install -yyq npm

# Get Nitrogen - this is a repo of submodules to make life easier
mkdir nitrogen
cd nitrogen
git clone https://github.com/nitrogenjs/service.git
git clone https://github.com/nitrogenjs/admin.git

# Start the service
cd service
sudo npm install
cp /vagrant/nitrogen-service.conf /etc/init/nitrogen-service.conf
start nitrogen-service

# Start the admin app 
cd ../admin
npm install -g yo grunt-cli bower
npm install
bower --allow-root install
gem install compass
cp /vagrant/nitrogen-admin.conf /etc/init/nitrogen-admin.conf
start nitrogen-admin
