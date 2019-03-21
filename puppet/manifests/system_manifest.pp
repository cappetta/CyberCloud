# @author: cappetta <thomas.cappetta>AT<gmail>
##########################################################################################
### Reference Notes:
##########################################################################################
# REF: http://www.puppetcookbook.com/posts/install-multiple-packages.html
# REF https://docs.puppetlabs.com/references/latest/type.html#file
# REF: https://www.digitalocean.com/community/tutorials/getting-started-with-puppet-code-manifests-and-modules
# REF
##########################################################################################
### Purpose: To Launch a series of machines from scratch and then install custom software
##### blueprints and registration processes.
##########################################################################################
### Approach:
##########################################################################################
#1) This is a cookbook.  You build systems like you cook a meal - planned and well thought-out.
#2) Approach Taken:
#   a. install packages
#   b. copy service configuration files
#   c. check critical services are running
#   d. add custom components
#     - monitoring framework - todo: deferred
#     - install vulnerable websites

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# http://askubuntu.com/questions/64729/how-to-change-the-wallpaper-of-all-clients-using-puppet
define set_bg($name) {
  exec {"set bg for $name":
    command => "/usr/bin/gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/warty-final-ubuntu.png",
    user => "$name",
  }
}

# Set-up the core Server
node 'core'{
#  todo: debug vhosts issues
# What Packages to install
$packages = [ 'httpd', 'vim-enhanced.x86_64', 'gedit', 'ossec-hids-server.x86_64', 'geoip', 'nc', 'htop','tcpdump', 'nmap' ]
package{ $packages:  ensure => "latest", notify => [Service['httpd'], Class['ossec::server']]}

exec {"Install Atomic repo":
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'wget https://www.atomicorp.com/installers/atomic && sudo chmod +x atomic && sudo ./atomic'
}

class { 'ossec::server':
mailserver_ip      => "gsmtp147.google.com",
ossec_emailto       => "personaldevelopmentjira@gmail.com",
ossec_emailfrom     => "personaldevelopmentjira@gmail.com",
notify              => Exec['Create RSA Key'],
}

exec {"Create FireWall Rule to accept traffic - INPUT":
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo iptables -I INPUT 1 -p udp --dport 1514 -s 192.168.0.0/24'
}
exec {"Create FireWall Rule to accept traffic - OUTPUT":
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo iptables -I OUTPUT 1 -p udp --dport 1514 -s 192.168.0.0/24'
}
# create rsa key
exec {"Create RSA Key":
path      => ["/usr/bin/","/usr/sbin/","/bin"],
command   => 'sudo openssl genrsa -out /var/ossec/etc/sslmanager.key 2048',
notify    => Exec['Create SSL x509 Certificate']
}

# create SSL certificate
exec {"Create SSL x509 Certificate":
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo openssl req -new -x509 -key /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert -subj "/C=US/ST=NY/L=CyberArena/O=CyberLab/OU=R&D Department/CN=lab.com" -days 365',
notify => Exec['Start OSSEC Authd']
}

exec {"Start OSSEC Authd":
path    => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo /var/ossec/bin/ossec-authd -p 1515 > /dev/null 2>&1 &'
}


# Group HTTP Services together and figure out how to set pre-requisets allowing execution after pre-conditions are met
exec { "WebServer Directory":
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo cp /vagrant/puppet/modules/httpd/files/httpd.conf /etc/httpd/conf/httpd.conf',
require => Package['httpd']
}

service {'httpd':
name => 'httpd',
ensure => 'running',
enable => 'true',
require => Package['httpd'],
#    subscribe => File['/etc/httpd/conf/httpd.conf']
}

# todo: setup automated OSSEC certificate generation
### Setup Certificates and open authentication - manually exit out after all are registered
# REF: http://dcid.me/blog/2011/01/automatically-creating-and-setting-up-the-agent-keys/
# sudo openssl genrsa -out /var/ossec/etc/sslmanager.key 2048
# sudo openssl req -new -x509 -key /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert -days 365
# sudo /var/ossec/bin/ossec-authd -p 1515 >/dev/null 2>&1 &
#

####  Continuous Build of Application Components

exec { "Disable ipv6":
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo cp /vagrant/puppet/modules/website/files/sysctl.conf /etc/'
}


#  exec {"Post BootStrap Files":
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'cp -R /vagrant/puppet/modules/website/files/bootstrap /var/www/html/ciBootstrap/application/libraries'
#  }

#  exec {"Post Angular Files":
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'cp -R /vagrant/puppet/modules/website/files/angular /var/www/html/ciBootstrap/application/libraries'
#  }
# todo: Fix Package does not exist error
#  exec {"Enable VirtualBox Guest Add-ons": # REF; http://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'sudo yum --enablerepo rpmforge install dkms'
#  }
##########################################################
# Caution - Group Installs are manually managed packages.
##########################################################
exec {"Install Development Tools": # REF; http://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo yum groupinstall -y "Development Tools"'
}

exec {"Install developer kernal": # REF; http://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest
path => ["/usr/bin/","/usr/sbin/","/bin"],
command => 'sudo yum install -y kernel-devel'
}
}

# todo: setup and deploy initial bootstrap framework - convert to ciBootStrap_deploy.sh or better yet an application specific deployment
#  exec {"Copy":
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'cp /vagrant/puppet/modules/website/files/CodeIgniter-Bootstrap-master.zip /var/www/html'
#  }
#
#  exec {"Unzip":
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'unzip /var/www/html/CodeIgniter-Bootstrap-master.zip',
#  }

#  exec {"Move into Place":
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'mv /var/www/html/CodeIgniter-Bootstrap-master.zip /var/www/html/ciBootStrap',
#  }

#  file { "/var/www/html":
#    mode   => 755,
#    owner  => apache,
#    group  => apache,
#  #    source => "puppet:///modules/website/phpinfo.php"
#  }



##############################################
### - CLEAN-UP
#  package { 'httpd':
#    ensure => absent,
#  }
#
#  service {'httpd':
#  name => 'httpd',
#  ensure => 'stopped',
#  enable => 'false',
#  }

#### Example: Display dependency error w/ PHP ####
#  package {'httpd':
#    ensure => absent
#  }



# todo: global submodule add
#Need to add git submodules to get puppet classes working
#git submodule add https://github.com/example42/puppet-apache.git puppet/modules/apache



#
#node 'couchbase' {
##
#  $packages = [ "apache2", "couchbase", "vim","virtualbox-guest-dkms",  "virtualbox-guest-utils","virtualbox-guest-x11", "ubuntu-desktop"] #, "gdm" ]
#  package{ $packages: ensure => "latest" }
## todo: debug
#  exec { "couchbase-server-source":
#    command => "/usr/bin/wget http://packages.couchbase.com/releases/2.0.1/couchbase-server-enterprise_x86_64_2.0.1.deb",
#    cwd => "/home/vagrant/",
#    creates => "/home/vagrant/couchbase-server-enterprise_x86_64_2.0.1.deb",
#    before => Package['couchbase-server']
#  }
#
#
#  exec { "couchbase-server-source":
#    command => "sudo dpkg -i couchbase-server version.deb",
#
#  }
#
#  package { "couchbase-server":
#    provider => dpkg,
#    ensure => installed,
#    source => "/home/vagrant/couchbase-server-enterprise_x86_64_2.0.1.deb"
#  }


node 'agent1','agent2', 'agent3' {

  apt::source { 'ubuntu-ossec':
    location   => 'https://launchpad.net/~nicolas-zin/+archive/ubuntu/ossec-ubuntu',
    repos      => 'main',
    key        => '0C4FF926',
    key_server => 'keyserver.ubuntu.com',
  }
# Add ossec ubuntu repo (same as above, simplier)
#  apt::ppa {'ppa:nicolas-zin/ossec-ubuntu': }


# What Packages to install
  $packages = [ "git", "apache2", "php5", "php5-mcrypt", "vim", "ubuntu-desktop", "xfce4","virtualbox-guest-dkms",  "virtualbox-guest-utils","virtualbox-guest-x11", "build-essential", "libapache2-mod-php5", "apache2-utils", 'tcpdump' ]
  package{ $packages: ensure => "latest", notify => [ Service['apache2'], Exec['Install Custom Background'] ] }

# PRIVATE KEY Deployment.
  exec { "Distribute Shared SSH Key for Git CLi":
    path    => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'cp /vagrant/puppet/shared_git_key /home/vagrant/.ssh/id_rsa'
  }
# todo: find gdm pacakge and fix defect / test w/ ubuntu desktop
#  exec {"Configure System for GUI Login":
#  path => ["/usr/bin/","/usr/sbin/","/bin"],
#  command => 'sudo cp /vagrant/puppet/modules/gdm/custom.conf /etc/gdm/'
#  }

  service {'apache2':
    name    => 'apache2',
    ensure  => 'running',
    enable  => 'true',
  }

# install ossec client
  class { "ossec::client":
    ossec_server_ip => "192.168.0.42",
    notify          => Exec['Register OSSEC Server'],
  }

  exec {"Create FireWall Rule to accept traffic - INPUT":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo iptables -I INPUT 1 -p udp --dport 1514 -s 192.168.0.0/24'
  }
  exec {"Create FireWall Rule to accept traffic - OUTPUT":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo iptables -I OUTPUT 1 -p udp --dport 1514 -s 192.168.0.0/24'
  }


  exec {"Register OSSEC Server":
    path    => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo /var/ossec/bin/agent-auth -m 192.168.0.42 -p 1515'
  }

# install mysql
#  class { "mysql" : }

# install custom background
#  file { "/usr/share/backgrounds/warty-final-ubuntu.png":
#    source => "puppet://server/vagrant/puppet/modules/ossec/puppets-ubuntu-wallpaper.jpg"
#  }

  exec {"Install Custom Background":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo cp /vagrant/puppet/modules/ossec/files/puppets-ubuntu-wallpaper.jpg /usr/share/backgrounds/warty-final-ubuntu.png'
  }

#  set_bg{ "vagrant": name => "vagrant"}

}
#
#}
