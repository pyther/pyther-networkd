class networkd::params {

  $disable_services = $::osfamily ? {
    'RedHat' => ['NetworkManager', 'network'],
    default  => [],
  }

  if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease == 7) {
    $package_name   = 'systemd-networkd'
    $package_ensure = 'installed'
    $package_manage = true
  }
  else {
    $package_name   = 'systemd'
    $package_ensure = undef
    $package_manage = false
  }

}

