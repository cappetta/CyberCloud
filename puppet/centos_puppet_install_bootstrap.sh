#!/usr/bin/env bash


if ! type "puppet" > /dev/null; then
    puppetHome="/tmp/vagrant/puppet-bootstrap"
    cd /tmp/vagrant/puppet-bootstrap
    chmod 755 ./centos_6_x.sh;
    sudo ./centos_6_x.sh
fi

# Install puppet modules before launching puppet scripts - these can be executed locally as the application user
puppet module install puppetlabs-apache
puppet module install puppetlabs-apt
puppet module install puppetlabs-motd
puppet module install andyshinn-atomic

## install atomic depencency
#wget https://www.atomicorp.com/installers/atomic && sudo chmod +x atomic && sudo ./atomic
#
## install epel report for geoip *.so dependency
#wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#sudo rpm -Uvh epel-release-6*.rpm
#



# feature: Applications are linked to common subdirectory of shared host folder
if ! [ -L /var/www ]; then
  rm -rf /var/www
 sudo ln -fs /vagrant/www /var/www
fi