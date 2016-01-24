require 'spec_helper'

describe 'networkd::network' do
  let :pre_condition do
    'class { "networkd": conf_dir => "/etc/systemd/networkd" }'
  end

  let :default_facts do
    {
      :concat_basedir => '/dne',
    }
  end

  context 'example-1' do
    let(:title) { 'enp2s0' }
    let :params do
      {
        :match => { 'name' => 'enp2s0' },
        :network => { 'address' => '192.168.0.15/24', 'gateway' => '192.168.0.1' },
      }
    end

    let :facts do default_facts end

    it { is_expected.to contain_class("networkd") }
    it { is_expected.to contain_concat__fragment('network_enp2s0-match') }
    it { is_expected.to contain_concat__fragment('network_enp2s0-match').with(
      :content => /^Name=enp2s0$/ ) }
    it { is_expected.to contain_concat__fragment('network_enp2s0-network') }
    it { is_expected.to contain_concat__fragment('network_enp2s0-network').with(
      :content => /Address=192.168.0.15\/24\nGateway=192.168.0.1/ ) }
    it do should contain_file('enp2s0.network').with({
      'ensure' => 'present',
      'path'   => '/etc/systemd/networkd/enp2s0.network',
      })
    end

    #it do
    #  $stdout.puts self.catalogue.to_yaml
    #  should contain_file('enp2s0.network').with_content(/\s*Gateway=192.168.0.1/)
    #end
  end
end
