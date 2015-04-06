# -*- mode: ruby -*-
# vi: set ft=ruby :
#
unless Vagrant.has_plugin?("vagrant-hostsupdater")
  #%x(vagrant plugin install vagrant-omnibus) unless Vagrant.has_plugin?('vagrant-omnibus')
	raise 'vagrant-hostsupdater not installed. Try run \'vagrant plugin install vagrant-hostsupdater\''
end
VAGRANT_APP_DOMAIN = "kiiiosk.dev"
VAGRANT_HOSTNAME = "vagrant"
VAGRANT_IP = '192.168.10.201'
Vagrant.configure("2") do |config|
	#config.vm.box = 'ubuntu/trusty32'
  # Should work on OSX 10.9, VirtualBox 4.3.2, Vagrant 1.3.5
  config.vm.box = "ubuntu-14.04-LTS"
  config.vm.box_url =
    "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

	config.vm.network :private_network, ip: VAGRANT_IP
  # config.vm.network :public_network, :bridge => 'en0: Wi-Fi (AirPort)'
	config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 3001, host: 3001
  config.vm.network :forwarded_port, guest: 9000, host: 9000
  config.vm.network :forwarded_port, guest: 9001, host: 9001
  #config.vm.network :forwarded_port, guest: 80, host: 3000

	config.vm.network :forwarded_port, id: 'ssh', guest: 22, host: 2222
  config.vm.hostname = 'vagrant'
	config.vm.synced_folder "./", "/home/vagrant/vagrant"

  # Speedup syncing folders
  # http://chase-seibert.github.io/blog/2014/03/09/vagrant-cachefilesd.html

  if Dir.exists? './code'
    if ENV['USE_NFS'] == 'true'
      config.vm.synced_folder "./code", "/home/vagrant/code", type: 'nfs', mount_options: ['rw', 'vers=3', 'tcp', 'fsc'] 
    else 
      config.vm.synced_folder "./code", "/home/vagrant/code"
    end
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine
    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    #config.cache.synced_folder_opts = {
      #type: :nfs,
      ## The nolock option can be useful for an NFSv3 client that wants to avoid the
      ## NLM sideband protocol. Without this option, apt-get might hang if it tries
      ## to lock files needed for /var/cache/* operations. All of this can be avoided
      ## by using NFSv4 everywhere. Please note that the tcp option is not the default.
      #mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    #} 
  end

  # ssh for windows
  # https://github.com/DSpace/vagrant-dspace/blob/master/Vagrantfile#L153
  #
  config.ssh.forward_agent = true
  config.ssh.pty = false

  # kiosk subdomains
  subdomains = [nil]
  subdomains += %w(www admin test demo shop assets wannabe cc app api thumbor)
  subdomains << '*' if RUBY_PLATFORM =~ /darwin/
  config.hostsupdater.aliases = subdomains.map { |s| [s,VAGRANT_APP_DOMAIN].compact * '.' }

	config.vm.provider :virtualbox do |vm|
		vm.customize ["modifyvm", :id, "--name", VAGRANT_APP_DOMAIN]
    if ENV['VM_MEM']
      vm.customize ["modifyvm", :id, "--memory", [ENV['VM_MEM'].to_i, 3072].max]
    end

    # vagrant-faster сам подбирает нужные парметры
    # на mac pro 4 cpu, 8Gb отдает 2 cpu и 2Gb
		#cpu_count = 2
		#if RUBY_PLATFORM =~ /linux/
			#cpu_count = `nproc`.to_i
		#elsif RUBY_PLATFORM =~ /darwin/
			#cpu_count = `sysctl -n hw.ncpu`.to_i
		#end
		#vm.customize ["modifyvm", :id, "--cpus", cpu_count]
		vm.customize ["modifyvm", :id, "--ioapic", "on"]
		vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end

  # Example from Stan
  # https://gist.github.com/senotrusov/f5665286b593edd054a3
  #
  config.vm.provision "shell", path: 'provisions/system.sh'
  config.vm.provision "shell", path: 'provisions/cachefilesd.sh'
  config.vm.provision "shell", path: 'provisions/locale.sh'
  config.vm.provision "shell", path: 'provisions/elastic.sh'
  config.vm.provision "shell", path: 'provisions/postgresql.sh'
  config.vm.provision "shell", path: 'provisions/nodejs.sh'
  config.vm.provision "shell", path: 'provisions/tmux.sh',  privileged: false
  config.vm.provision "shell", path: 'provisions/shell.sh', privileged: false
  config.vm.provision "shell", path: 'provisions/ruby.sh',  privileged: false
  config.vm.provision "shell", path: 'provisions/geoip.sh'
  config.vm.provision "shell", path: 'provisions/kiosk.sh', privileged: false

	config.vm.define :kiiiosk do |kiiiosk|
		kiiiosk.vm.hostname = VAGRANT_HOSTNAME
	end

	config.vm.post_up_message = "\n\nProvisioning is done. 
Visit http://#{VAGRANT_APP_DOMAIN} for test and development kiiiosk application!
Projects directory is: /home/vagrant/code
PostgreSQL User is: postgres
SSH Access: ssh vagrant@#{VAGRANT_IP}
System password is: vagrant
Current OS: Ubuntu GNU/Linux 14.4 x64"
end
