define networkd::link (
  $enable = true,
  $ensure = 'present',

  $match = undef,
  $link = undef,
  ) {
  
  $sections = [
    [ 'match', $match ],
    [ 'link', $link ],
  ]
  
  $sections.each |Integer $index, Array $section| {
    if $section[1] and !is_hash($section[1]) {
      fail("networkd::link[${name}]: '${section[0]}' must be a Hash")
    }
  }

  concat { "${name}.link":
    ensure => present,
    path   => "/tmp/${name}.link",
  }

  $sections.each |Integer $index, Array $section| {
    if $section[1] and !empty($section[1]) {
      concat::fragment { "link_${name}-${section[0]}":
        target  => "${name}.link",
        order   => $index,
        content => template("networkd/link/_${section[0]}.erb"),
      }
    }
  }

}
