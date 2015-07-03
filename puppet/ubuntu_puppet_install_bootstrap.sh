#!/usr/bin/env bash

if ! type "puppet" > /dev/null; then
    puppetHome="/home/vagrant/puppet"
    cd /tmp/vagrant/puppet-bootstrap
    chmod 755 ubuntu.sh;
    sudo ./ubuntu.sh
fi
# Install puppet modules before launching puppet scripts - these can be executed locally as the application user
puppet module install puppetlabs-apache
puppet module install puppetlabs-apt
puppet module install puppetlabs-motd

sudo apt-get install -y build-essential

# ##########################################
if ! [ -L /var/www ]; then
  rm -rf /var/www
 sudo ln -fs /vagrant/www /var/www
fi


