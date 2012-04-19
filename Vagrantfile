Vagrant::Config.run do |config|
  config.vm.box = "centos6"
  config.vm.forward_port 3000, 3000
  
  # Puppet
  config.vm.provision :puppet do |puppet| 
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
  end
  
end
