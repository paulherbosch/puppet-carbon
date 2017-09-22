# Define: carbon::relay::instance
#
define carbon::relay::instance (
  $config
) {

  $user = $carbon::user
  $group = $carbon::group
  $log_dir = $carbon::log_dir

  exec { "reload systemctl /usr/lib/systemd/system/carbon-relay-${title}.service":
    command   => '/bin/systemctl daemon-reload',
    onlyif    => "/usr/bin/systemctl status carbon-relay-${title} 2>&1 | /usr/bin/grep \"[c]hanged on disk\"",
    subscribe => File["/usr/lib/systemd/system/carbon-relay-${title}.service"],
    notify    => Service["carbon-relay-${title}"]
  }

  service { "carbon-relay-${title}":
    ensure => running
  }

  file { "/usr/lib/systemd/system/carbon-relay-${title}.service":
    ensure  => present,
    content => template('carbon/carbon-relay-systemd.erb'),
  }

  augeas { "carbon-relay-${title}":
    lens    => 'Puppet.lns',
    incl    => '/etc/carbon/carbon-relay.conf',
    context => '/files/etc/carbon/carbon-relay.conf',
    changes => $config,
    require => File['/etc/carbon/carbon-relay.conf'],
  }

}
