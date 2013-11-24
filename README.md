#cinder

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Resources managed by cinder module](#resources-managed-by-cinder-module)
    * [Setup requirements](#setup-requirements)
    * [Beginning with module cinder](#beginning-with-module-cinder)
4. [Usage](#usage)
5. [Operating Systems Support](#operating-systems-support)
6. [Development](#development)

##Overview

This module installs, manages and configures cinder and its services.

##Module Description

The module is based on **stdmod** naming standards version 0.9.0.

Refer to [http://github.com/stdmod/](http://github.com/stdmod/) for complete documentation on the common parameters.

For a fully automated Puppet setup of OpenStack you'd better use the official [StackForge modules](https://github.com/stackforge/puppet-openstack).
This module is intended to be a quick replacement for setups where you want to manage configurations based on plain template files or where you want to puppettize an existing OpenStack installation.

##Setup

###Resources managed by cinder module
* This module installs the cinder package (in case of multiple services, the cinder-api package is installed)
* Enables the cinder service (in case of multiple services, the cinder-api service is managed)
* Can manage all the configuration files (by default no file is changed)
* Can manage any cinder service and its configuration file (by default no file is changed)

###Setup Requirements
* PuppetLabs [stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)
* StdMod [stdmod module](https://github.com/stdmod/stdmod)
* Puppet version >= 2.7.x
* Facter version >= 1.6.2

###Beginning with module cinder

To install the package provided by the module just include it:

        include cinder

The main class arguments can be provided either via Hiera (from Puppet 3.x) or direct parameters:

        class { 'cinder':
          parameter => value,
        }

The module provides a generic define to manage any cinder configuration file in /etc/cinder:

        cinder::conf { 'sample.conf':
          content => '# Test',
        }

A define to manage the package/service/configfile of single cinder services. To install the package and run the service:

        cinder::generic_service { 'cinder-registry': }

To provide a configuration file for the service (alternative to cinder::conf):

        cinder::generic_service { 'cinder-registry':
          config_file_template => 'site/cinder/cinder-registry.conf
        }

##Usage

* A common way to use this module involves the management of the main configuration file via a custom template (provided in a custom site module):

        class { 'cinder':
          config_file_template => 'site/cinder/cinder.conf.erb',
        }

* You can write custom templates that use setting provided but the config_file_options_hash paramenter

        class { 'cinder':
          config_file_template      => 'site/cinder/cinder.conf.erb',
          config_file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }

* Use custom source (here an array) for main configuration file. Note that template and source arguments are alternative.

        class { 'cinder':
          config_file_source => [ "puppet:///modules/site/cinder/cinder.conf-${hostname}" ,
                                  "puppet:///modules/site/cinder/cinder.conf" ],
        }


* Recurse from a custom source directory for the whole configuration directory (/etc/cinder).

        class { 'cinder':
          config_dir_source  => 'puppet:///modules/site/cinder/conf/',
        }

* Use custom source directory for the whole configuration directory and purge all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'cinder':
          config_dir_source => 'puppet:///modules/site/cinder/conf/',
          config_dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'cinder':
          config_dir_source    => 'puppet:///modules/site/cinder/conf/',
          config_dir_recursion => false, # Default: true.
        }

* Do not trigger a service restart when a config file changes.

        class { 'cinder':
          config_dir_notify => '', # Default: Service[cinder]
        }

##Operating Systems Support

This is tested on these OS:
- RedHat osfamily 6
- Ubuntu 12.04


##Development

Pull requests (PR) and bug reports via GitHub are welcomed.

When submitting PR please follow these quidelines:
- Provide puppet-lint compliant code
- If possible provide rspec tests
- Follow the module style and stdmod naming standards

When submitting bug report please include or link:
- The Puppet code that triggers the error
- The output of facter on the system where you try it
- All the relevant error logs
- Any other information useful to undestand the context
