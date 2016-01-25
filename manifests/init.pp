#
# = Class: networkd
#
# This class installs and manges systemd-networkd
#
# == Parameters
#
# [*network_hash*]
#   a hash of network configs
#
# [*link_hash*]
#  a hash of link configs
#
# [*netdev_hash*]
#   a hash of netdev configs
#
# [*conf_dir*]
#  config directory for networkd
#
# [*conf_dir_manage*]
#  Boolean. Whether or not to manage the config directory
#
# [*conf_dir_purge*]
#   Boolean. Whether or not puppet should remove unmanaged files in config dir
#
# [*conf_dir_recurse*]
#   Boolean. Whether or not puppet should recurse through the config dir
#
# [*package_name*]
#   name of the networkd package. This useful only on RHEL7
#
# [*package_ensure*]
#   ensure state of the package
#
# [*service_enable*]
#   Boolean. Enable state for systemd-networkd
#
# [*wait_online_service_enable*]
#   Boolean. Enable state for service: systemd-networkd-wait-online
#
# [*service_manage*]
#   Boolean. Whether or not to manage the networkd service
#
# [*disabled_services*]
#   Array of services to disable. Ex: NetworkManager, network
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
  $package_ensure   = 'installed',

  $service_enable   = true,
  $service_manage   = true,
  $wait_online_service_enable = false,

  $disabled_services = []

  ) inherits ::networkd::params {

  validate_bool($conf_dir_manage)
  validate_bool($conf_dir_purge)
  validate_bool($conf_dir_recurse)

  validate_bool($service_enable)
  validate_bool($service_manage)

  validate_array($disabled_services)

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
  if $package_name {
    package { $package_name:
      ensure => $package_ensure,
      before => [Service['systemd-networkd'], Service['systemd-networkd-wait-online']],
    }
  }

  # enable systemd-networkd service
  if $service_manage {
    service { 'systemd-networkd':
      enable => $service_enable,
    }
    service { 'systemd-networkd-wait-online':
      enable => $wait_online_service_enable,
    }
  }

  # disable Networking Service such as NetworkManager and network
  if $disabled_services and !empty($disabled_services) {
    service { $disabled_services:
      enable => false,
    }
  }
}
