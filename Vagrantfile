# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
    puppet.manifest_file  = "development.pp"
  end
  
  config.vm.provision :shell, :path => "bootstrap.sh"  
  
  # port forward
  config.vm.network :forwarded_port, host: 3000, guest: 3000
  config.vm.synced_folder ".", "/home/vagrant/hpi-hiwi-portal"  
end