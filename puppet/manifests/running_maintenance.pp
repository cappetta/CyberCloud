

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

node 'ubuntuClient','hidclient' {
# Ensure apache is up & listing for new file changes
  service {'apache2':
    name    => 'apache2',
    ensure  => 'running',
    enable  => 'true',
    require => Package['apache2'],

  }


  exec {"Register OSSEC Server":
    path    => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo /var/ossec/bin/agent-auth -m 192.168.0.42 -p 1515'
  }

  service {'mysqld':
    name    => 'mysqld',
    ensure  => 'running',
    enable  => 'true',
    require => Package['mysql-server'],

  }


  exec {"Install Custom Background":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo cp /vagrant/puppet/modules/ossec/files/puppets-ubuntu-wallpaper.jpg /usr/share/backgrounds/warty-final-ubuntu.png'
  }

  set_bg{ "vagrant": name => "vagrant"}

}

########################################################
#####  CentosCore Server
# Description of Purpose:
#
########################################################

node 'centosCore'{

# What Packages maintain
  $packages = [ 'httpd', 'vim-enhanced.x86_64', 'gedit', 'ossec-hids-server.x86_64', 'geoip', 'nc', 'htop','tcpdump', 'nmap' ]
  package{ $packages: ensure => "latest", notify => [Service['httpd']] }

  exec { "Restart OSSEC Server":
    path    => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo /var/ossec/bin/ossec-control restart'
  }
#todo: build logic which starts & stops the AuthD service. (e.g. Hourly registration cycles)
  exec { "Start OSSEC Authd":
    path    => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo /var/ossec/bin/ossec-authd -p 1515 > /dev/null 2>&1 &'
  }
  service {'httpd':
    name => 'httpd',
    ensure => 'running',
    enable => 'true',
  }
}
#
node 'couchbase' {
## Ensure Core Services are Up and Running
  service {'httpd':
    name => 'httpd',
    ensure => 'running',
    enable => 'true',
  }

}


#  exec {"Post BootStrap Files":
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'cp -R /vagrant/puppet/modules/website/files/bootstrap /var/www/html/ciBootstrap/application/libraries'
#  }

#  exec {"Post Angular Files":
#    path => ["/usr/bin/","/usr/sbin/","/bin"],
#    command => 'cp -R /vagrant/puppet/modules/website/files/angular /var/www/html/ciBootstrap/application/libraries'
#  }
