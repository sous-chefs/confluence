# Base hostname
cookbook = 'confluence'

Vagrant.configure('2') do |config|
  config.berkshelf.enabled = true
  config.cache.auto_detect = true
  config.omnibus.chef_version = :latest

  config.vm.define :centos6 do |centos6|
    centos6.vm.box      = 'chef/centos-6.6'
    centos6.vm.hostname = "#{cookbook}-centos-6"
  end

  config.vm.define :centos7 do |centos6|
    centos7.vm.box      = 'chef/centos-7.1'
    centos7.vm.hostname = "#{cookbook}-centos-7"
  end

  config.vm.define :ubuntu1204 do |ubuntu1204|
    ubuntu1204.vm.box      = 'chef/ubuntu-12.04'
    ubuntu1204.vm.hostname = "#{cookbook}-ubuntu-1204"
  end

  config.vm.define :ubuntu1404 do |ubuntu1304|
    ubuntu1304.vm.box      = 'chef/ubuntu-13.04'
    ubuntu1304.vm.hostname = "#{cookbook}-ubuntu-1404"
  end

  config.vm.network :private_network, ip: '192.168.50.10'

  config.vm.provider 'virtualbox' do |v|
    v.customize ['modifyvm', :id, '--memory', 1024]
  end

  config.vm.provision :chef_zero do |chef|
    chef.log_level = :debug
    chef.json = {
      'postgresql' => {
        'password' => {
          'postgres' => 'iloverandompasswordsbutthiswilldo'
        }
      },
      'confluence' => {
        'database' => {
          'type' => 'postgresql'
        }
      }
    }
    chef.run_list = [
      "recipe[#{cookbook}]"
    ]
  end
end
