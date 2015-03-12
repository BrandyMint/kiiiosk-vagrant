# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?("vagrant-hostsupdater")
  raise 'vagrant-hostsupdater not installed. Try run \'vagrant plugin install vagrant-hostsupdater\''
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
VAGRANT_APP_DOMAIN = "kiiiosk.dev"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "http://kiiiosk.ru/system/kiiiosk.box"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  config.vm.network "forwarded_port", guest: 3000, host: 3000

  subdomains = [nil]
  subdomains += %w(www api admin thumbor)
  subdomains << '*' if RUBY_PLATFORM =~ /darwin/

  config.hostsupdater.aliases = subdomains.map { |s| [s,VAGRANT_APP_DOMAIN].compact * '.' }

  config.ssh.forward_agent = true

  #config.vm.synced_folder "./", "/home/vagrant/vagrant"
  config.vm.synced_folder "./code", "/home/vagrant/code"
  config.vm.synced_folder "~/.ssh", "/home/vagrant/.host_ssh"

  config.vm.provision "shell", path: 'provision.sh', privileged: false

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.


end
