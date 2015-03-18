#!/bin/bash

export DEBIAN_FRONTEND=noninteractive;
export PATH=/home/vagrant/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

apt-get install -y software-properties-common;


tee /etc/apt/sources.list > /dev/null 2>&1 <<EOF
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) main restricted
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) main restricted
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates main restricted
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates main restricted
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) universe
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) universe
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates universe
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates universe
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu $(lsb_release -cs)-security main restricted
deb-src http://security.ubuntu.com/ubuntu $(lsb_release -cs)-security main restricted
deb http://security.ubuntu.com/ubuntu $(lsb_release -cs)-security universe
deb-src http://security.ubuntu.com/ubuntu $(lsb_release -cs)-security universe
deb http://security.ubuntu.com/ubuntu $(lsb_release -cs)-security multiverse
deb-src http://security.ubuntu.com/ubuntu $(lsb_release -cs)-security multiverse
deb http://archive.canonical.com/ubuntu $(lsb_release -cs) partner
deb-src http://archive.canonical.com/ubuntu $(lsb_release -cs) partner
EOF
wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
add-apt-repository -y ppa:webupd8team/java;
add-apt-repository -y 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main';
add-apt-repository -y 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main'

apt-get update
apt-get -y upgrade
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections;

apt-get -y install language-pack-ru \
  oracle-java7-installer build-essential bundler ca-certificates git imagemagick \
  libmagickwand-dev libmysqlclient-dev lsb-release mdbtools mdbtools-dev memcached nodejs nodejs-legacy npm \
  openssl rake redis-server geoip-database-contrib libsqlite3-dev libpq-dev zsh libyaml-dev libreadline-dev \
  elasticsearch postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 htop mc tcpdump nano && echo 'OK' || true;

update-rc.d elasticsearch defaults 95 10;
/usr/share/elasticsearch/bin/plugin -l|grep HQ || /usr/share/elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ;
/usr/share/elasticsearch/bin/plugin -l|grep analysis-morphology || /usr/share/elasticsearch/bin/plugin -install analysis-morphology -url http://dl.bintray.com/content/imotov/elasticsearch-plugins/org/elasticsearch/elasticsearch-analysis-morphology/1.2.0/elasticsearch-analysis-morphology-1.2.0.zip;

npm install -g bower;

tee /etc/postgresql/9.4/main/pg_hba.conf > /dev/null 2>&1 <<EOF
local   all             postgres                                trust
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
EOF

grep PGUSER=postgres /home/vagrant/.profile || sudo -iu vagrant echo "export PGUSER=postgres;" >> $HOME/.profile
grep "PATH=/home/vagrant/.rbenv" /home/vagrant/.profile  || sudo -iu vagrant echo "export PATH=/home/vagrant/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> $HOME/.profile
grep "rbenv init" /home/vagrant/.profile || sudo -iu vagrant echo 'eval "$(rbenv init -)"'>> $HOME/.profile


sudo -iu vagrant git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv;
test -d /home/vagrant/.rbenv/plugins/ruby-build || sudo -iu vagrant git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build;
sudo -iu vagrant echo 'gem: --no-ri --no-rdoc' >> /home/vagrant/.gemrc;
sudo -iu vagrant rbenv versions| grep 2.1.5 || rbenv install 2.1.5 --verbose;
sudo -iu vagrant rbenv local 2.1.5;
sudo -iu vagrant rbenv exec gem install bundler
test -d /home/vagrant/code || mkdir /home/vagrant/code;
apt-get clean

git clone git@github.com:BrandyMint/merchantly.git ~/code/kiiiosk.dev

cd ~/code/kiiiosk.dev

git submodule init
git submodule update
bower install
bundle
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

exit 0;
