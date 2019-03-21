
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node 'agent1','agent2', 'agent3' {
  $packages = [ 'git', 'apache2', 'php5',
  'php5-mcrypt', 'vim', 'ubuntu-desktop',
  'xfce4','virtualbox-guest-dkms','virtualbox-guest-utils',
  'virtualbox-guest-x11', 'build-essential', 'libapache2-mod-php5',
  'apache2-utils', 'tcpdump', 'mysql-client-5.5',
  'mysql-server-5.5','mysql-common','libmysqlclient18',
  'libgda-5.0-mysql','php5-mysql','python-mysqldb'
]

  package{ $packages:
    ensure                => "latest",
    notify                => [
      Service['apache2'],
      Exec['Install Custom Background']
    ]
  }

  exec {"Install Custom Background":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo cp /vagrant/puppet/modules/website/files/puppets-ubuntu-wallpaper.jpg /usr/share/backgrounds/warty-final-ubuntu.png'
  }

# Set Mysql Overrides
  $override_options = {
'restart' => true,
}

# Install Mysql
  class { '::mysql::server':
    root_password           => "secret",
    remove_default_accounts => true,
    override_options        => $override_options,
    notify                  => [
    ]
  }

  exec {"Create FireWall Rule to accept traffic - INPUT":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo iptables -I INPUT 1 -p udp --dport 1514 -s 192.168.0.0/24'
  }

  exec {"Create FireWall Rule to accept traffic - OUTPUT":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'sudo iptables -I OUTPUT 1 -p udp --dport 1514 -s 192.168.0.0/24'
  }

# install ossec client
  class { "ossec::client":
      ossec_server_ip         => "192.168.0.12",
      notify                  => [
          Exec['Create FireWall Rule to accept traffic - INPUT'],
          Exec['Create FireWall Rule to accept traffic - OUTPUT'],
          Exec['Register OSSEC Server']
      ]
  }

  exec {"Register OSSEC Server":
    path                      => ["/usr/bin/","/usr/sbin/","/bin"],
    command                   => 'sudo /var/ossec/bin/agent-auth -m 192.168.0.12 -p 1515',
    notify                    => [
          Exec["Install Damn Vulnerable Web App"]
    ]
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

}

