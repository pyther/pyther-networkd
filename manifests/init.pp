#
# = Class: networkd
#
# This class installs and manges systemd-networkd
#
# == Parameters
#
#
#
class networkd (
  $network_hash = undef,
  $netdev_hash = undef,
  $link_hasht = undef,

  $conf_dir         = '/etc/systemd/networkd',
  $conf_dir_manage  = true,
  $conf_dir_purge   = false,
  $conf_dir_recurse = true,

  $purge_directory  = true,

  $package_name     = $::networkd::params::package_name,
  $package_ensure   = $::networkd::params::package_ensure,
  $package_manage   = $::networkd::params::package_manage,

  $service_name     = 'systemd-networkd',
  $service_enable   = true,
  $service_manage   = true,

  $disable_services = $::networkd::params::disable_services

  ) inherits ::networkd::params {

  validate_bool($conf_dir_manage)
  validate_bool($conf_dir_purge)
  validate_bool($conf_dir_recurse)

  validate_bool($service_manage)
  validate_bool($package_manage)


  if $network_hash { validate_hash($network_hash) }
  if $netdev_hash { validate_hash($netdev_hash) }
  if $link_hash { validate_hash($link_hash) }

  # create from hashes
  if $network_hash {
    create_resources('networkd::network', $network_hash)
  }
  if $netdev_hash {
    create_resources('networkd::netdev', $netdev_hash)
  }
  if $link_hash {
    create_resources('networkd::link', $link_hash)
  }

  # manage /etc/systemd/networkd
  if $conf_dir_manage {
    file { $conf_dir:
      ensure  => directory,
      purge   => $conf_dir_purge,
      recurse => $conf_dir_recurse,
    }
  }

  # install systemd-network package
  if $package_manage {
    package { $package_name:
      ensure => $package_ensure,
    }
  }

  # enable systemd-networkd service
  if $service_manage {
    service { $service_name:
      enable => $service_enable,
    }
  }

  # disable Networking Service such as NetworkManager and network
  if $disabled_services and !empty($disabled_services) {
    service { $disabled_services:
      enable => false,
    }
  }
}
