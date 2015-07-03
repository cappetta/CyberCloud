define website::helloWorld() {

  file { "/var/www/${name}":
    source  => "puppet:///modules/website/${name}",
    require => Package['apache2'],
    notify  => Service['apache2'];
  }