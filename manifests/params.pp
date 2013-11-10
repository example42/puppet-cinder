# Class: cinder::params
#
# Defines all the variables used in the module.
#
class cinder::params {

  $package_name = $::osfamily ? {
    'Redhat' => 'openstack-cinder',
    default  => 'cinder',
  }

  $service_name = $::osfamily ? {
    'Redhat' => 'openstack-cinder',
    default  => 'cinder',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/cinder/cinder.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/cinder',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}
