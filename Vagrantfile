# -*- mode: ruby -*-
# vi: set ft=ruby :
#
unless Vagrant.has_plugin?("vagrant-hostsupdater")
	raise 'vagrant-hostsupdater not installed. Try run \'vagrant plugin install vagrant-hostsupdater\''
end
VAGRANT_APP_DOMAIN = "kiiiosk.dev"
Vagrant.configure("2") do |config|
	config.vm.box = 'ubuntu/trusty32'
	config.vm.network :private_network, ip: '192.168.10.201'
	config.vm.network :forwarded_port, guest: 3000, host: 3000
	config.vm.network :forwarded_port, id: 'ssh', guest: 22, host: 2222
	config.vm.hostname = VAGRANT_APP_DOMAIN
	config.vm.synced_folder "./", "/home/vagrant/vagrant"
  config.vm.synced_folder "./code", "/home/vagrant/code"

  # ssh for windows
  # https://github.com/DSpace/vagrant-dspace/blob/master/Vagrantfile#L153
  #
  config.ssh.forward_agent = true
  config.ssh.pty = true

  # kiosk subdomains
  subdomains = [nil]
  subdomains += %w(www api admin thumbor)
  subdomains << '*' if RUBY_PLATFORM =~ /darwin/
  config.hostsupdater.aliases = subdomains.map { |s| [s,VAGRANT_APP_DOMAIN].compact * '.' }

	config.vm.provider :virtualbox do |vm|
		vm.customize ["modifyvm", :id, "--name", "kiiiosk.dev"]
		vm.customize ["modifyvm", :id, "--memory", [ENV['MERCHANTLY_VM_MEM'].to_i, 3072].max]
		cpu_count = 2
		if RUBY_PLATFORM =~ /linux/
			cpu_count = `nproc`.to_i
		elsif RUBY_PLATFORM =~ /darwin/
			cpu_count = `sysctl -n hw.ncpu`.to_i
		end
		vm.customize ["modifyvm", :id, "--cpus", cpu_count]
		vm.customize ["modifyvm", :id, "--ioapic", "on"]
		vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end

	config.vm.provision "shell", path: 'provision.sh'
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"

	config.vm.define :kiiiosk do |kiiiosk|
		kiiiosk.vm.hostname = "#{VAGRANT_APP_DOMAIN}"
	end
	config.vm.post_up_message = "\n\nProvisioning is done. 
Visit http://#{VAGRANT_APP_DOMAIN} for test and development kiiiosk application!
Projects directory is: /home/vagrant/code
PostgreSQL User is: postgres
SSH Access: ssh vagrant@192.168.10.201
System password is: vagrant
Current OS: Ubuntu GNU/Linux 14.4 x64"
end
