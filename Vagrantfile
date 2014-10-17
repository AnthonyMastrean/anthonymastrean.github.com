VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.network "forwarded_port", guest: 4000, host: 4000
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end
end
