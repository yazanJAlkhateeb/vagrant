Vagrant.configure(2) do |config|
  config.vm.box = "psmssqltc8amq"
  config.vm.box_url = "https://artifactory.psdevelop.com/artifactory/api/vagrant/PS-VagrantBoxes/psmssqltc8amq"
  config.vm.hostname="PSYSJO"

  # basic ports
  config.vm.network "forwarded_port", guest: 8080, host: 48080
  config.vm.network "forwarded_port", guest: 22,   host: 40022
  config.vm.network "forwarded_port", guest: 8000,   host: 48000
  config.vm.network "forwarded_port", guest: 1433,   host: 41433

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4000"
    vb.cpus=2
    vb.name="PSYSJO"
  end
end