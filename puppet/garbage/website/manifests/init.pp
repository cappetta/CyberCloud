# == Class: httpd
#
# Installs packages for Apache2, enables modules, and sets config files.
#
class website {
  website::conf { ['httpd.conf']: }
  website::helloWorld { ['index.php']: }
}
