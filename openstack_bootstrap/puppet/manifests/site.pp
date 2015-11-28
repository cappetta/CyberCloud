#node 'opscenter'{
## install script handles the install
#}
node 'opscenter' {
  include ::cassandra::datastax_repo
  include ::cassandra
  include ::cassandra::opscenter
}

# match any datastax nodes "node#" naming convention
node /^agent\d+$/ {
  include cappetta-datastax::base_profile
  include cappetta-datastax::profile_cassandra_3
  include cappetta-datastax::refresh_cluster_3
}

#
node graphite {
#  include cappetta-datastax::base_profile
#  include cappetta-datastax::profile_jmxtrans
#  include cappetta-datastax::refresh_graphite
  class { 'grafana':
    cfg => {
      app_mode => 'production',
      server   => {
        http_port     => 8080,
      },
      database => {
        type          => 'sqlite3',
        host          => '127.0.0.1:3306',
        name          => 'grafana',
        user          => 'root',
        password      => '',
      },
      users    => {
        allow_sign_up => false,
      },
    },
  }
}

#
node /^minecraft+$/ {
  include cappetta-datastax::base_profile
  include cappetta-datastax::profile_minecraft
}

node default {

}