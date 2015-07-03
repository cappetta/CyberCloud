# goal is to create a manifest framework for install ossims via puppet

# ubuntu ppa:

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


node 'ossim' {
  include apt
#  include mysql::server

 $OSSIM_HOME='/vagrant/alienvault-ossim/os-sim/db/'
  exec {"Set OSSIM_PATH environmental Variable":
      path => ["/usr/bin/","/usr/sbin/","/bin"],
      command => "export OSSIM_HOME='$OSSIM_HOME'",
#      notify => [ Exec[''] ]
    }
#  trying to install via source
# Add ossim ubuntu repo
#  apt::ppa { 'ppa:ossim/ppa': }

#Install Mysql
  class { '::mysql::server':
    root_password           => "secret",
    remove_default_accounts => true,
    override_options        => $override_options,
  }

   $override_options = {
     'restart' => true,
   }

  mysql_database { 'snort':
    ensure => 'present',
  }
#  mysql::sql  { [ '$OSSIM_HOME/db/.sql', ]# $OSSIM_HOME+'/db/ossim_data.sql', $OSSIM_HOME+'/db/snort_nessus.sql', $OSSIM_HOME+'/db/realsecure.sql' ]
#  }
mysql::db { 'ossim':
ensure => 'present',
user => 'ossim',
password => 'ossim'
}

# What Packages to install
#  $packages = [ "git", "vim","virtualbox-guest-dkms",  "virtualbox-guest-utils","virtualbox-guest-x11", "build-essential", "apache2-utils", 'tcpdump', 'nmap', 'autoconf', 'automake','gcc','libglib2.0-dev','libgda2-dev','gda2-mysql','libgnet-dev', 'apache-ssl', 'php4','php4-cgi','libphp-adodb', 'php4-mysql','php4-pgsql','php4-gd2','libphp-phplot','libphp-jpgraph','wwwconfig-common','php4-domxml','php4-xslt', 'python','python-dev','python-mysqldb','python-pgsql', 'snort']
  $packages = [ "git", "vim","virtualbox-guest-dkms",  "virtualbox-guest-utils","virtualbox-guest-x11", "build-essential", "apache2-utils", 'tcpdump', 'nmap', 'autoconf', 'automake','gcc','libglib2.0-dev','libgda2-dev','gda2-mysql','libgnet-dev', 'apache-ssl', 'php5','php5-cgi','libphp-adodb', 'php5-mysql','php5-pgsql','php5-gd2','libphp-phplot','libphp-jpgraph','wwwconfig-common','php5-domxml','php5-xslt', 'python','python-dev','python-mysqldb','python-pgsql', 'snort']
  package{ $packages: ensure => "latest"  }

  apt::source { 'Deb Testing':
  comment           => 'Installing apt-dependencies',
  location          => 'http://ftp.debian.org/debian/',
  repos             => 'testing main',
  include_src       => true,
  include_deb       => true
  }
  apt::source { 'Deb Secure Testing':
  comment           => 'Installing apt-dependencies',
  location          => 'http://secure-testing.debian.net/debian-secure-testing',
  repos             => 'testing/security-updates main',
  include_src       => true,
  include_deb       => true
  }
  apt::source { 'OSSIM download':
  comment           => 'Installing apt-dependencies',
  location          => 'http://www.ossim.net/download/',
  repos             => 'debian/',
  include_src       => true,
  include_deb       => true,
  notify            => Exec['Apt-get Update']
  }

  apt::source { 'Debian Source Repo':
  comment           => 'Supports the installation of OSSIM via source build',
  location          => 'http://http.us.debian.org/debian',
  repos             => 'sarge main contrib non-free',
  include_src       => true,
  include_deb       => true,
  notify            => Exec['Apt-get Update'] # Always refresh
  }



  apt::pin{'ossim': priority => 995 }
#  apt::update{ }

  exec {"Apt-get Update":
  path => ["/usr/bin/","/usr/sbin/","/bin"],
  command => 'sudo apt-get update'
  }

  $secondaryPackages = ['linux-image-2.6-686','hdparm','deborphan', 'dpkg-dev', 'fakeroot',]
  package{ $secondaryPackages: ensure => 'latest',
  }

  exec {"get SNORT/ACID SQL files":
    path => ["/usr/bin/","/usr/sbin/","/bin"],
    command => 'apt-get source snort-mysql acidlab',
    notify => [ Exec['Apply Acid.patch'] ]
  }
  
  exec {"Apply Acid.patch":
      path => ["/usr/bin/","/usr/sbin/","/bin"],
      command => 'zcat /usr/share/doc/snort-mysql/contrib/create_mysql.gz | mysql -u root snort ;cat /usr/share/acidlab/create_acid_tbls_mysql.sql | mysql -u root snort '
#      notify => [ Exec[''] ]
    }
  
}