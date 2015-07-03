
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


# depreciated by using the ossim box w/ UVM installed.  There are still erros to work out in the unsupported manual build process.
node 'ossim-depreciated' {
  include apt

  apt::source { 'Debian Source Repo':
    comment           => 'Supports the installation of OSSIM via source build',
    location          => 'http://http.us.debian.org/debian',
    repos             => 'sarge main contrib non-free',
    include_src       => true,
    include_deb       => true,
    notify            => Exec['Apt-get Update'] # Always refresh
  }

  $packages = [ "git", "vim","virtualbox-guest-dkms",  "virtualbox-guest-utils","virtualbox-guest-x11", 'openjdk-6-jdk','python-nmap','nmap','python-ldap','python-libpcap','python-adodb','automake','libtool','autoconf','intltool','e2fsprogs','hdparm','unzip','libglib2.0-dev','gnet2.0','libgnet2.0','libgnet-dev','libxml2','libxml2-dev','libxslt1-dev','openssl','libssl-dev','uuid','uuid-dev','json-glib-1.0','libjson-glib-1.0','libjson-glib-dev','python-dev','php5-geoip','geoip-bin','geoip-database','libgeoip1','libgeoip-dev','python-geoip','geoclue','geoclue-hostip','geoclue-localnet','geoclue-manual','geoclue-yahoo','libgeoclue0','fprobe','fprobe-ng','mysql-client-5.5','mysql-server-5.5','mysql-common','libmysqlclient18','libgda-5.0-mysql','php5-mysql','python-mysqldb','snort-mysql','libxml-simple-perl','libdbi-perl','libdbd-mysql-perl','libapache-dbi-perl','libnet-ip-perl','libsoap-lite-perl', 'libgda-4.0-4','libsoup2.4']
  package{ $packages: ensure => "latest"  }

  exec {"Instally OSSIM Source":
      path => ["/usr/bin/","/usr/sbin/","/bin"],
      command => 'sudo cp -R /vagrant/alienvault-ossim/ /opt/ossim'
    }

  exec {"Apt-get Update":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo apt-get update'
  }

  exec {"execute pre-build-steps":
      path => ["/usr/bin/","/usr/sbin/","/bin"],
      command => 'sudo /opt/ossim/os-sim/pre-build-steps.sh'
  #    notify => [ Exec[''] ]
    }
}


node 'agent1','agent2', 'agent3' {


# What Packages to install
  $packages = [ "git", "apache2", "php5", "php5-mcrypt", "vim", "ubuntu-desktop", "xfce4","virtualbox-guest-dkms",  "virtualbox-guest-utils","virtualbox-guest-x11", "build-essential", "libapache2-mod-php5", "apache2-utils", 'tcpdump', 'mysql-client-5.5','mysql-server-5.5','mysql-common','libmysqlclient18','libgda-5.0-mysql','php5-mysql','python-mysqldb' ]
  package{ $packages: ensure => "latest", notify => [ Service['apache2'], Exec['Install Custom Background'] ] }

#Install Mysql
  class { '::mysql::server':
    root_password           => "secret",
    remove_default_accounts => true,
    override_options        => $override_options,
  }

$override_options = {
    'restart' => true,
  }

# install ossec client
  class { "ossec::client":
    ossec_server_ip => "192.168.0.12",
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
    command => 'sudo /var/ossec/bin/agent-auth -m 192.168.0.12 -p 1515'
  }
  
  exec {"Install Damn Vulnerable Web App":
      path => ["/usr/bin/","/usr/sbin/","/bin"],
      command => 'sudo cp -R /vagrant/puppet/modules/website/files/DVWA /var/www/html/'
    }

  service {'apache2':
    name    => 'apache2',
    ensure  => 'running',
    enable  => 'true',
  }
  exec {"Install Custom Background":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo cp /vagrant/puppet/modules/ossec/files/puppets-ubuntu-wallpaper.jpg /usr/share/backgrounds/warty-final-ubuntu.png'
  }

}
#
#}
