# Class: carbon::config
#
class carbon::config (
  $config_dir,
  $storage_dir,
  $log_dir,
  $user,
  $group
) {

  file { $config_dir :
    ensure => directory,
    owner  => $user,
    group  => $group
  }

  file { $storage_dir :
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750'
  }

  file { $log_dir :
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750'
  }

  file { "${config_dir}/storage-schemas.conf":
    ensure  => file,
    owner   => $user,
    group   => $group,
    replace => false,
    source  => "puppet:///modules/${module_name}/storage-schemas.conf"
  }

  file { "${config_dir}/storage-aggregation.conf":
    ensure  => file,
    owner   => $user,
    group   => $group,
  }

  file { "${config_dir}/carbon-cache.conf":
    ensure  => file,
    owner   => $user,
    group   => $group,
    replace => false,
    content => template("${module_name}/carbon-cache.conf.erb")
  }

  file { "${config_dir}/carbon-relay.conf":
    ensure  => file,
    owner   => $user,
    group   => $group,
    replace => false,
    content => template("${module_name}/carbon-relay.conf.erb")
  }

}
