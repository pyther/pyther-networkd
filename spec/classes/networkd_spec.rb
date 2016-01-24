require 'spec_helper'

describe 'networkd' do

  context 'defaults' do
    it { should_not create_package('systemd-networkd') }
    it { should create_service('systemd-networkd') }
  end

  context 'rhel7 include systemd-networkd' do
    let :facts do
    {
     :osfamily => 'RedHat',
     :operatingsystemmajrelease => 7,
    }
    end
    it { should create_package('systemd-networkd') }
    it { should create_service('systemd-networkd') }
  end

  context 'do not manage system things' do
    let :params do
    {
      :package_manage => false,
      :service_manage => false,
      :conf_dir_manage => false,
    }

    it { should_not create_package('systemd-networkd') }
    it { should_not create_service('systemd-networkd') }
    it { should_not create_file('/etc/systemd/networkd') }
    end
  end

  context 'disable systemd-networkd' do
    let(:params) { {:service_enable => false} }

    it { should create_service('systemd-networkd').with({'enable' => false,}) }
  end

end
