# Define: carbon::cache::instance
#
define carbon::cache::instance (
  $config
) {

  $user = $carbon::user
  $group = $carbon::group
  $log_dir = $carbon::log_dir

  exec { "reload systemctl /usr/lib/systemd/system/carbon-cache-${title}.service":
    command   => '/bin/systemctl daemon-reload',
    onlyif    => "/usr/bin/systemctl status carbon-cache-${title} 2>&1 | /usr/bin/grep \"[c]hanged on disk\"",
    subscribe => File["/usr/lib/systemd/system/carbon-cache-${title}.service"],
    notify    => Service["carbon-cache-${title}"]
  }

  service { "carbon-cache-${title}":
    ensure => running
  }

  file { "/usr/lib/systemd/system/carbon-cache-${title}.service":
    ensure  => present,
    content => template('carbon/carbon-cache-systemd.erb'),
  }

  augeas { "carbon-cache-${title}":
    lens    => 'Puppet.lns',
    incl    => '/etc/carbon/carbon-cache.conf',
    context => '/files/etc/carbon/carbon-cache.conf',
    changes => $config,
    require => File['/etc/carbon/carbon-cache.conf'],
  }

}
