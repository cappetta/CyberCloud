# == Define: conf
#
# Adds an Apache configuration file.
#
define website::conf() {
  file { "/etc/httpd/${name}":
    source  => "puppet:///modules/website/${name}",
    require => Package['apache2'],
    notify  => Service['apache2'];
  }

}

