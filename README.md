#networkd

####Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [Resources managed by networkd module](#resources-managed-by-networkd-module)
    * [Setup requirements](#setup-requirements)
    * [Beginning with module networkd](#beginning-with-module-networkd)
3. [Usage](#usage)
    * [Network](#network)
    * [NetDev](#netdev)
    * [Link](#link)
4. [Hiera examples](#hiera-examples)
5. [Operating Systems Support](#operating-systems-support)
6. [Development](#development)

##Module Description

The networkd module managed network interfaces using systemd-networkd.

## Setup

###Resources managed by networkd module
* This module enables the systemd-networkd service
* This module installs the systemd-networkd package (RHEL7)
* This module manages /etc/systemd/networkd

###Setup Requirements
* PuppetLabs [stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)
* PuppetLabs [concat module](https://github.com/puppetlabs/puppetlabs-concat)
* Puppet version >= 4.x

###Beginning with module networkd

All configuration parameters come from the systemd-networkd man pages.
* `systemd.network(5)`
* `systemd.netdev(5)`
* `systemd.link(5)`

Use the `networkd::network`, `networkd::link`, or `networkd::netdev` define types.

    networkd::network { '10-enp2s0':
      mask    => { name => 'enp2s0', }
      network => {
        address => '192.168.1.12/24',
        gateway => '192.168.1.1',
      },
    }

## Usage

### network

Example 1

    networkd::network { '50-static':
      match   => { name => 'enp2s0', },
      network => {
        address => '192.168.0.15/24',
        gateway => '192.168.0.1',
      },
    }

Example 2

    networkd::network { '80-dhcp':
      match   => { name => 'en*', },
      network => { dhcp => 'yes', },
    }

Example 3

    networkd::network { '25-bridge-static':
      match   => { name => 'bridge0', },
      network => {
        address => '192.168.0.15/24',
        gateway => '192.168.0.1',
        dns     => '192.168.0.1',
      },
    }

Example 4

    networkd::network { '25-bridge-slave-interface':
      match   => { name => 'enp2s0', },
      network => {
        bridge  => 'bridge0',
      },
    }

Example 5

    networkd::network { '25-ipip':
      match   => { name => 'em1', },
      network => { tunnel => 'ipip-tun', },
    }

Example 6

    networkd::network { '25-sit':
      match   => { name => 'em1', },
      network => { tunnel => 'sit-tun', },
    }

Example 7

    networkd::network { '25-gre':
      match   => { name => 'em1', },
      network => { tunnel => 'gre-tun', },
    }

Example 8

    networkd::network { '25-vti':
      match   => { name => 'em1', },
      network => { tunnel => 'vti-tun', },
    }

Example 9

    networkd::network { '25-bond':
      match   => { name => 'bond1', },
      network => { dhcp => 'yes', },
    }

### netdev
Example 1

    networkd::netdev { '25-bridge':
      netdev => {
        name => 'bridge0',
        kind => 'bridge',
      },
    }

Example 2

    networkd::netdev { '25-vlan1':
      match  => { virtualization => 'no' },
      netdev => {
        name => 'vlan1',
        kind => 'vlan',
      },
      vlan   => { 'id' => 1 },
    }

Example 3

    netword::netdev { '25-ipip':
      netdev => {
        name      => 'ipip-tun',
        kind      => 'ipip',
        mtu_bytes => '1480',
      },
      tunnel   => {
        'local'  => '192.168.223.238',
        'remote' => '192.169.224.239',
        'ttl'    => '64'
      },
    }


Example 4

    netword::netdev { '25-tap':
      netdev => {
        name => 'tap-test',
        kind => 'tap',
      },
      tap   => {
        'multi_queue' => true,
        'packet_info' => true,
      },
    }

Example 5

    netword::netdev { '25-sit':
      netdev => {
        name => 'sit-tun',
        kind => 'sit',
      },
      tunnel   => {
        'local'  => '10.65.223.238',
        'remote' => '10.65.223.239',
      },
    }

Example 6

    netword::netdev { '25-gre':
      netdev => {
        name      => 'gre-tun',
        kind      => 'gre',
        mtu_bytes => '1480',
      },
      tunnel   => {
        'local'  => '10.65.223.238',
        'remote' => '10.65.223.239',
      },
    }

Example 7

    netword::netdev { '25-vti':
      netdev => {
        name      => 'vti-tun',
        kind      => 'vti',
        mtu_bytes => '1480',
      },
      tunnel   => {
        'local'  => '10.65.223.238',
        'remote' => '10.65.223.239',
      },
    }

Example 8

    netword::netdev { '25-veth':
      netdev => {
        name => 'veth-test',
        kind => 'veth',
      },
      peer   => {
        'name' => 'veth-peer',
      },
    }

Example 9

    netword::netdev { '25-bond':
      netdev => {
        name => 'bond1',
        kind => 'bond',
      },
      bond   => {
        'mode'                 => '802.3ad',
        'transmit_hash_policy' => 'layer3+4',
        'mii_monitor_sec'      => '1s',
        'lacp_transmit_rate'   => 'fast',
      },
    }

Example 10

    netword::netdev { '25-dummy':
      netdev => {
        name        => 'dummy-test',
        kind        => 'dummy',
        mac_address => '12:34:56:78:9a:bc',
      },
    }

### Link
Assigns the fixed name "dmz0" to the interface with the MAC address `00:a0:de:63:7a:e6`:

    network::link { '10-dmz':
      match => { mac_address => '00:a0:de:63:7a:e6' },
      link  => { name  => 'dmz0' },
    }

Assigns the fixed name "internet0" to the interface with the device path "pci-0000:00:1a.0-*"

    network::link { '10-internet':
      match => { path => 'pci-0000:00:1a.0-*' },
      link  => { name => 'internet0' },
    }

Overly complex example that shows the use of a large number of [Match] and [Link] settings.

    network::link { '25-wireless.link':
      match => {
        mac_address    => '12:34:56:78:9a:bc',
        driver         => 'brcmsmac',
        path           => 'pci-0000:02:00.0-*',
        type           => 'wlan',
        virtualization => 'no',
        host           => 'my-laptop',
        architecture   => 'x86-64',
      },
      link => {
        name            => 'wireless0',
        mtu_bytes       => '1450',
        bits_per_second => '10M',
        wake_on_lan     => 'magic',
        mac_address     => 'cb:a9:87:65:43:21',
      },
    }

##Hiera examples

Here are some examples of usage via Hiera (with yaml backend)

Two interfaces via dhcp:

    networkd::network_hash:
      40-enp2s0:
        match:
          name: enp2s0
        network:
          dhcp: yes
      40-enp2s1:
        match:
          name: enp2s0
        network:
          dhcp: yes

Bond interface:
    networkd::netdev_hash:
      25-bond:
        netdev:
          name: bond1
          kind: bond
        bond:
          mode: 802.3ad
          transmit_hash_policy: layer3+4
          mii_monitor_sec: 1s
          lacp_transmit_rate: fast

    networkd::network_hash:
      25-bond:
        match:
          name: bond1
        network:
          dhcp: yes
      25-enp1s0:
        match:
          name: enp1s0
        network:
          bond: bond1
      25-enp1s1:
        match:
          name: enp1s1
        network:
          bond: bond1


##Operating Systems Support

Tested on RedHat 7. Should theoratically work on any system with systemd-networkd.

## Development

Pull requests (PR) and bug reports via GitHub are welcomed.

When submitting PR please follow these quidelines:
- Provide puppet-lint compliant code
- If possible provide rspec tests

When submitting bug report please include or link:
- The Puppet code that triggers the error
- The output of facter on the system where you try it
- All the relevant error logs
- Any other information useful to undestand the context
