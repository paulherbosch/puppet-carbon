# Class: carbon::user
#
class carbon::user (
  $ensure     = present,
  $user       = $carbon::params::user,
  $group      = $carbon::params::group
) inherits carbon::params {

  file { '/home/carbon':
    ensure => directory,
    owner  => 'carbon',
    group  => 'carbon',
    mode   => '0750'
  }

  user { $user :
    ensure => present,
    home   => '/home/carbon',
    gid    => $group
  }

  group { $group :
    ensure => present
  }

}
