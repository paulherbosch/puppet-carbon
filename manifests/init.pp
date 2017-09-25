# Class: carbon
#
class carbon (
  $version,
  $ensure         = present,
  $config_dir     = $carbon::params::config_dir,
  $storage_dir    = $carbon::params::storage_dir,
  $log_dir        = $carbon::params::log_dir,
  $user           = $carbon::params::user,
  $group          = $carbon::params::group,
  $storage_schema = []
) inherits carbon::params {

  validate_string($user)
  validate_string($group)

  #anchor {'carbon::begin': }
  class { 'carbon::packages':
    carbon_version => $version
  }

  class { 'carbon::user': }

  class { 'carbon::config':
    config_dir     => $config_dir,
    storage_dir    => $storage_dir,
    log_dir        => $log_dir,
    user           => $user,
    group          => $group,
    storage_schema => $storage_schema
  }

}
