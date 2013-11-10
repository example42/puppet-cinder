# = Class: cinder::example42
#
# Example42 puppi additions. To add them set:
#   my_class => 'cinder::example42'
#
class cinder::example42 {

  puppi::info::module { 'cinder':
    packagename => $cinder::package_name,
    servicename => $cinder::service_name,
    processname => 'cinder',
    configfile  => $cinder::config_file_path,
    configdir   => $cinder::config_dir_path,
    pidfile     => '/var/run/cinder.pid',
    datadir     => '',
    logdir      => '/var/log/cinder',
    protocol    => 'tcp',
    port        => '5000',
    description => 'What Puppet knows about cinder' ,
    # run         => 'cinder -V###',
  }

  puppi::log { 'cinder':
    description => 'Logs of cinder',
    log         => [ '/var/log/cinder/api.log' , '/var/log/cinder/registry.log' ],
  }

}
