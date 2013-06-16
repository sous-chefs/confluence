# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"

# ensure the cache path exists
FileUtils.mkdir(host_cache_path) unless File.exist?(host_cache_path)

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.define :centos6 do |dist_config|
    dist_config.vm.hostname = 'confluence-centos-6'
    dist_config.vm.box       = 'opscode-centos-6.3'
    dist_config.vm.box_url   = 'https://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-6.3_chef-provisionerless.box'
    
    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
    end

    dist_config.vm.network :private_network, ip: '192.168.50.10'

    config.vm.synced_folder host_cache_path, guest_cache_path

    dist_config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.log_level         = :debug

      chef.json = {
        "java" => {
          "install_flavor" => "oracle",
          "jdk_version" => "7",
          "oracle" => {
            "accept_oracle_download_terms" => true
          }
        },
        "mysql" => {
          "server_root_password" => "iloverandompasswordsbutthiswilldo",
          "server_repl_password" => "iloverandompasswordsbutthiswilldo",
          "server_debian_password" => "iloverandompasswordsbutthiswilldo"
        }
      }

      chef.run_list = %w{
        recipe[java]
        recipe[confluence]
      }
    end
  end

  config.vm.define :ubuntu1204 do |dist_config|
    dist_config.vm.hostname = 'confluence-ubuntu-1204'
    dist_config.vm.box       = 'opscode-ubuntu-12.04'
    dist_config.vm.box_url   = 'https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box'

    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
    end
    
    dist_config.vm.network :private_network, ip: '192.168.50.11'

    config.vm.synced_folder host_cache_path, guest_cache_path

    dist_config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.log_level         = :debug

      chef.json = {
        "java" => {
          "install_flavor" => "oracle",
          "java_home" => "/usr/lib/jvm/java-7-oracle",
          "jdk_version" => "7",
          "oracle" => {
            "accept_oracle_download_terms" => true
          }
        },
        "mysql" => {
          "server_root_password" => "iloverandompasswordsbutthiswilldo",
          "server_repl_password" => "iloverandompasswordsbutthiswilldo",
          "server_debian_password" => "iloverandompasswordsbutthiswilldo"
        }
      }

      chef.run_list = %w{
        recipe[java]
        recipe[confluence]
      }
    end
  end
end