# Class: carbon::packages
#
class carbon::packages (
  $carbon_version,
  $ensure = 'present',
) {

  $python_pip = 'python2-pip'

  package { ['gcc','cairo-devel','libffi-devel','python-devel',$python_pip]:
    ensure => $ensure
  }

  file { ['/usr/bin/python-pip','/usr/bin/pip-python']:
    ensure  => link,
    target  => '/usr/bin/pip',
    require => Package[$python_pip]
  }

  # BUG: https://github.com/graphite-project/graphite-web/issues/1838
  package { ['twisted']:
    ensure   => '16.0.0',
    provider => 'pip',
    require  => Package[$python_pip]
  }
  package { ['pyopenssl']:
    ensure   => '17.3.0',
    provider => 'pip',
    require  => Package[$python_pip]
  }
  package { ['whisper']:
    ensure   => $carbon_version,
    provider => 'pip',
    require  => Package[$python_pip]
  }
  package { ['service_identity']:
    ensure   => 'present',
    provider => 'pip',
    require  => Package[$python_pip]
  }

  # BUG: https://serverfault.com/questions/358151/pip-install-carbon-looks-like-it-works-but-pip-disagrees-afterward
  exec {
    'install-carbon':
      command => "/usr/bin/pip install carbon==${carbon_version}",
      creates => "/opt/graphite/lib/carbon-${carbon_version}-py2.7.egg-info",
      require => Package[$python_pip]
  }
  # This is probably not the best place to install graphite, but since it's needed in our setup to serve carbon..
  exec {
    'install-graphite-web':
      command => "/usr/bin/pip install graphite-web==${carbon_version}",
      creates => "/opt/graphite/webapp/graphite_web-${carbon_version}-py2.7.egg-info",
      require => Package[$python_pip]
  }

}
