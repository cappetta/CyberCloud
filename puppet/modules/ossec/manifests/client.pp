# Setup for ossec client
class ossec::client(
  $ossec_active_response = true,
  $ossec_server_ip
) {
  include ossec::common

  case $::osfamily {
    'Debian' : {
      package { $ossec::common::hidsagentpackage:
        ensure  => installed,
        require => Apt::Ppa['ppa:nicolas-zin/ossec-ubuntu'],
      }
    }
    'RedHat' : {
      package { 'ossec-hids':
        ensure  => installed,
        require => Class['atomic'],
      }
      package { $ossec::common::hidsagentpackage:
        ensure  => installed,
        require => Package['ossec-hids'],
      }
    }
    default: { fail('OS family not supported') }
  }

  service { $ossec::common::hidsagentservice:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    pattern   => $ossec::common::hidsagentservice,
    require   => Package[$ossec::common::hidsagentpackage],
  }

  concat { '/var/ossec/etc/ossec.conf':
    owner   => 'root',
    group   => 'ossec',
    mode    => '0440',
    require => Package[$ossec::common::hidsagentpackage],
    notify  => Service[$ossec::common::hidsagentservice]
  }
  concat::fragment { 'ossec.conf_10' :
    target  => '/var/ossec/etc/ossec.conf',
    content => template('ossec/10_ossec_agent.conf.erb'),
    order   => 10,
    notify  => Service[$ossec::common::hidsagentservice]
  }
  concat::fragment { 'ossec.conf_99' :
    target  => '/var/ossec/etc/ossec.conf',
    content => template('ossec/99_ossec_agent.conf.erb'),
    order   => 99,
    notify  => Service[$ossec::common::hidsagentservice]
  }

  concat { '/var/ossec/etc/client.keys':
    owner   => 'root',
    group   => 'ossec',
    mode    => '0640',
    notify  => Service[$ossec::common::hidsagentservice],
    require => Package[$ossec::common::hidsagentpackage]
  }
  ossec::agentkey{ "ossec_agent_${::fqdn}_client":
    agent_id         => $::uniqueid,
    agent_name       => $::fqdn,
    agent_ip_address => $::ipaddress,
  }
  @@ossec::agentkey{ "ossec_agent_${::fqdn}_server":
    agent_id         => $::uniqueid,
    agent_name       => $::fqdn,
    agent_ip_address => $::ipaddress
  }
}


