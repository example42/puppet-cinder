#
# = Class: cinder
#
# This class installs and manages cinder
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class cinder (

  $conf_hash                 = undef,
  $generic_service_hash      = undef,

  $package_name              = $cinder::params::package_name,
  $package_ensure            = 'present',

  $service_name              = $cinder::params::service_name,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = $cinder::params::config_file_path,
  $config_file_replace       = $cinder::params::config_file_replace,
  $config_file_require       = 'Package[cinder]',
  $config_file_notify        = 'class_default',
  $config_file_source        = undef,
  $config_file_template      = undef,
  $config_file_content       = undef,
  $config_file_options_hash  = undef,
  $config_file_owner         = $cinder::params::config_file_owner,
  $config_file_group         = $cinder::params::config_file_group,
  $config_file_mode          = $cinder::params::config_file_mode,

  $config_dir_path           = $cinder::params::config_dir_path,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $dependency_class          = undef,
  $my_class                  = undef,

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $tcp_port                  = undef,
  $udp_port                  = undef,

  ) inherits cinder::params {


  # Class variables validation and management

  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  $manage_config_file_notify  = $config_file_notify ? {
    'class_default' => undef,
    ''              => undef,
    default         => $config_file_notify,
  }

  if $package_ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $manage_service_enable = $service_enable
    $manage_service_ensure = $service_ensure
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Resources managed

  if $cinder::package_name {
    package { 'cinder':
      ensure   => $cinder::package_ensure,
      name     => $cinder::package_name,
    }
  }

  if $cinder::config_file_path {
    file { 'cinder.conf':
      ensure  => $cinder::config_file_ensure,
      path    => $cinder::config_file_path,
      mode    => $cinder::config_file_mode,
      owner   => $cinder::config_file_owner,
      group   => $cinder::config_file_group,
      source  => $cinder::config_file_source,
      content => $cinder::manage_config_file_content,
      notify  => $cinder::manage_config_file_notify,
      require => $cinder::config_file_require,
    }
  }

  if $cinder::config_dir_source {
    file { 'cinder.dir':
      ensure  => $cinder::config_dir_ensure,
      path    => $cinder::config_dir_path,
      source  => $cinder::config_dir_source,
      recurse => $cinder::config_dir_recurse,
      purge   => $cinder::config_dir_purge,
      force   => $cinder::config_dir_purge,
      notify  => $cinder::manage_config_file_notify,
      require => $cinder::config_file_require,
    }
  }

  if $cinder::service_name {
    service { 'cinder':
      ensure     => $cinder::manage_service_ensure,
      name       => $cinder::service_name,
      enable     => $cinder::manage_service_enable,
    }
  }


  # Extra classes
  if $conf_hash {
    create_resources('cinder::conf', $conf_hash)
  }

  if $generic_service_hash {
    create_resources('cinder::generic_service', $generic_service_hash)
  }


  if $cinder::dependency_class {
    include $cinder::dependency_class
  }

  if $cinder::my_class {
    include $cinder::my_class
  }

  if $cinder::monitor_class {
    class { $cinder::monitor_class:
      options_hash => $cinder::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $cinder::firewall_class {
    class { $cinder::firewall_class:
      options_hash => $cinder::firewall_options_hash,
      scope_hash   => {},
    }
  }

}

