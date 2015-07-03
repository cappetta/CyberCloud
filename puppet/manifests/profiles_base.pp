
class profiles::base{

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  $packages = [ "git", "vim","virtualbox-guest-dkms",  "virtualbox-guest-utils","virtualbox-guest-x11",'python-nmap','nmap','python-ldap','python-libpcap','python-adodb','automake','libtool','autoconf','intltool','e2fsprogs','hdparm','unzip','libglib2.0-dev','gnet2.0','libgnet2.0','libgnet-dev','libxml2','libxml2-dev','libxslt1-dev','openssl','libssl-dev','uuid','uuid-dev','json-glib-1.0','libjson-glib-1.0','libjson-glib-dev','python-dev','php5-geoip','geoip-bin','geoip-database','libgeoip1','libgeoip-dev','python-geoip','geoclue','geoclue-hostip','geoclue-localnet','geoclue-manual','geoclue-yahoo','libgeoclue0','fprobe','fprobe-ng','mysql-client-5.5','mysql-server-5.5','mysql-common','libmysqlclient18','libgda-5.0-mysql','php5-mysql','python-mysqldb','snort-mysql','libxml-simple-perl','libdbi-perl','libdbd-mysql-perl','libapache-dbi-perl','libnet-ip-perl','libsoap-lite-perl', 'libgda-4.0-4','libsoup2.4']
  package{ $packages: ensure => "latest"  }

# Setup Application User
  group {'Create {{appGroup}} Group':
    name => '{{user}}',
    ensure => 'present',
    notify => [
      User['Create {{group}} User']
    ]
  }

  file {'Setup {{user}} home dir':
    path => '/home/{{user}}',
    ensure => 'directory',
    owner => '{{user}}',
    group => '{{user}}',
  #    notify => User['Create {{user}} User']
  }

  user { 'Create {{user}} User':
    name => "{{user}}",
    ensure => 'present',
    shell => '/bin/bash',
    gid => '{{gid}}',
    home => '/home/{{user}}',
    notify => [
      File['Setup {{user}} home dir']
    ]
  }

  service {'{{service}}':
    name    => '{{service}}',
    ensure  => 'running',
    enable  => 'true',
  }
}

