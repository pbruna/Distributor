Vagrant::Config.run do |config|
  config.vm.box = "centos6"
  config.vm.forward_port 3000, 3000
  config.vm.forward_port 80, 8080
 # config.vm.network :bridged
  
  # Puppet
  config.vm.provision :puppet do |puppet| 
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
  end
  
end
