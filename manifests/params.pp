class networkd::params {

  if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease == 7) {
    $package_name = 'systemd-networkd'
  }
  else {
    # networkd in shipped in the systemd package for most distributions
    $package_name = undef
  }

}

