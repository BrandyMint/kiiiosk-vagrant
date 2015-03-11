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
	config.vm.network :forwarded_port, guest: 3000, host: 8080
	config.vm.network :forwarded_port, id: 'ssh', guest: 22, host: 2222
	config.vm.hostname = VAGRANT_APP_DOMAIN
	config.ssh.forward_agent = true
	config.ssh.pty = true
	config.vm.synced_folder "./", "/home/vagrant/kiiiosk.dev"
	config.hostsupdater.aliases = [VAGRANT_APP_DOMAIN, "www.#{VAGRANT_APP_DOMAIN}", "api.#{VAGRANT_APP_DOMAIN}", "admin.#{VAGRANT_APP_DOMAIN}","thumbor.#{VAGRANT_APP_DOMAIN}"]
  config.hostsupdater.aliases << "*.#{VAGRANT_APP_DOMAIN}" if RUBY_PLATFORM =~ /darwin/
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


	config.vm.provision "shell", inline: "bash -c \"export DEBIAN_FRONTEND=noninteractive;
apt-get install software-properties-common;
cp /home/vagrant/kiiiosk.dev/vagrant-conf.d/sources.list /etc/apt/sources.list;
add-apt-repository -y ppa:webupd8team/java;
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections;
wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
add-apt-repository -y 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main';
add-apt-repository -y 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main'
apt-get update;
apt-get -y upgrade;
apt-get -y install oracle-java7-installer build-essential bundler ca-certificates git imagemagick \
  libmagickwand-dev libmysqlclient-dev lsb-release mdbtools mdbtools-dev memcached nodejs nodejs-legacy npm \
  openssl rake redis-server geoip-database-contrib libsqlite3-dev libpq-dev zsh libyaml-dev libreadline-dev \
  elasticsearch postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 htop mc tcpdump nano && echo 'OK' || true;
update-rc.d elasticsearch defaults 95 10;
\"
/usr/share/elasticsearch/bin/plugin -l|grep HQ || /usr/share/elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ;
/usr/share/elasticsearch/bin/plugin -l|grep analysis-morphology || /usr/share/elasticsearch/bin/plugin -install analysis-morphology -url http://dl.bintray.com/content/imotov/elasticsearch-plugins/org/elasticsearch/elasticsearch-analysis-morphology/1.2.0/elasticsearch-analysis-morphology-1.2.0.zip;
cp /home/vagrant/kiiiosk.dev/vagrant-conf.d/pg_hba.conf /etc/postgresql/9.4/main && service postgresql restart;
test -d /home/vagrant/.rbenv || sudo -iu vagrant bash -c \'git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv';
sudo -iu vagrant bash -c \'echo \"export PGUSER=postgres;export PATH=\"$HOME/.rbenv/bin:$PATH\"\" |tee -a  /home/vagrant/.profile';
test -d /home/vagrant/.rbenv/plugins/ruby-build || sudo -iu vagrant git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build;
sudo -iu vagrant echo 'gem: --no-ri --no-rdoc' >> /home/vagrant/.gemrc;
sudo -iu vagrant bash -c 'rbenv versions| grep 2.1.5 || rbenv install 2.1.5 --verbose';
sudo -iu vagrant bash -c 'rbenv local 2.1.5';
exit 0;
  "

	config.vm.define :kiiiosk do |kiiiosk|
		kiiiosk.vm.hostname = "#{VAGRANT_APP_DOMAIN}"
	end
	config.vm.post_up_message = "\n\nProvisioning is done. 
Visit http://#{VAGRANT_APP_DOMAIN} for test and development kiiiosk application!
Project root directory is: /home/vagrant/#{VAGRANT_APP_DOMAIN}
PostgreSQL User is: postgres
SSH Access: ssh vagrant@192.168.10.201
System password is: vagrant
Current OS: Ubuntu GNU/Linux 14.4 x64"
end
