VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.box_url = "https://vagrantcloud.com/hashicorp/precise32/version/1/provider/virtualbox.box"

  config.vm.provision "puppet"
end
