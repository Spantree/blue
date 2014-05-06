# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.5.1"

Vagrant.configure("2") do |config|

  config.vm.box = "spantree/ubuntu-precise-64"

  config.vm.synced_folder ".", "/usr/local/src/project", :create => "true"
  config.vm.synced_folder "puppet", "/usr/local/etc/puppet", :create => "true"
  #config.vm.synced_folder "~/.gnupg", "/root/.gnupg", :create => "true", :owner => "root"

  config.vm.hostname = "blue.spantree.net"
  config.vm.network :forwarded_port, host: 8080, guest: 8080

  config.vm.provider :virtualbox do |v, override|
    override.vm.network :private_network, ip: "192.168.80.100"
    v.customize ["modifyvm", :id, "--memory", 768]
  end

  config.vm.provision :shell, :path => "shell/initial-setup.sh", :args => "/vagrant/shell"
  config.vm.provision :shell, :path => "shell/update-puppet.sh", :args => "/vagrant/shell"
  config.vm.provision :shell, :path => "shell/librarian-puppet-vagrant.sh", :args => "/vagrant/shell"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.options = [
      "--verbose",
      "--debug",
      "--modulepath=/etc/puppet/modules:/usr/local/etc/puppet/modules",
      "--hiera_config /usr/local/src/project/hiera.yaml",
      "--parser future"
    ]
  end
end
