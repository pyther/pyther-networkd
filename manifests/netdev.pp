define networkd::netdev (
  $enable = true,
  $ensure = 'present',

  $bond = undef,
  $bridge = undef,
  $ipvlan = undef,
  $macvlan = undef,
  $macvtap = undef,
  $match = undef,
  $netdev = undef,
  $peer = undef,
  $tap = undef,
  $tun = undef,
  $tunnel = undef,
  $vlan = undef,
  $vxlan = undef,
  ) {

  $sections = [
    [ 'match', $match ],
    [ 'netdev', $netdev ],
    [ 'bridge', $bridge ],
    [ 'vlan', $vlan ],
    [ 'macvlan', $macvlan ],
    [ 'macvtap', $macvtap ],
    [ 'ipvlan', $ipvlan ],
    [ 'vxlan', $vxlan ],
    [ 'tunnel', $tunnel ],
    [ 'peer', $peer ],
    [ 'tun', $tun ],
    [ 'tap', $tap ],
    [ 'bond', $bond ],
  ]

  $sections.each |Integer $index, Array $section| {
    if $section[1] and !is_hash($section[1]) {
      fail("networkd::netdev[${name}]: '${section[0]}' must be a Hash")
    }
  }

  concat { "${name}.netdev":
    ensure => present,
    path   => "/tmp/${name}.netdev",
  }


  $sections.each |Integer $index, Array $section| {
    if $section[1] and !empty($section[1]) {
      concat::fragment { "netdev_${name}-${section[0]}":
        target  => "${name}.netdev",
        order   => $index,
        content => template("networkd/netdev/_${section[0]}.erb"),
      }
    }
  }

}
