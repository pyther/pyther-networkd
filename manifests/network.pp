define networkd::network (
  $enable = true,
  $ensure = 'present',

  $match = undef,
  $link = undef,
  $network = undef,
  $address = undef,
  $route = undef,
  $dhcp = undef,
  $dhcpserver = undef,
  $bridge = undef,
  $bridgefdb = undef,
  ) {

  include ::networkd

  $sections = [
    [ 'match', $match ],
    [ 'link', $link ],
    [ 'network', $network ],
    [ 'address', $address ],
    [ 'route', $route ],
    [ 'dhcp', $dhcp ],
    [ 'dhcpserver', $dhcpserver ],
    [ 'bridge', $bridge ],
    [ 'bridgefdb', $bridgefdb ],
  ]

  $sections.each |Integer $index, Array $section| {
    if $section[1] {
      if $section[0] =~ /address|route/ {
        if !is_hash($section[1]) and !(is_array($section[1]) and is_hash($section[1][0])) {
          fail("networkd::network[${name}]: '${section[0]}' must be either a Hash or an Array of Hashes")
        }
      }
      elsif !is_hash($section[1]) {
        fail("networkd::network[${name}]: '${section[0]}' must be a Hash")
      }
    }
  }

  concat { "${name}.network":
    ensure => present,
    path   => "${::networkd::conf_dir}/${name}.network",
  }

  $sections.each |Integer $index, Array $section| {
    if $section[1] and !empty($section[1]) {
      concat::fragment { "network_${name}-${section[0]}":
        target  => "${name}.network",
        order   => $index,
        content => template("networkd/network/_${section[0]}.erb"),
      }
    }
  }

}
