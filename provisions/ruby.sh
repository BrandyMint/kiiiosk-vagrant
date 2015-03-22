#!/usr/bin/zsh

# Ensure SQLite is installed
sudo apt-get install -y sqlite3 libsqlite3-dev
 
# Ensure ruby dependencies are installed
sudo apt-get install -y \
  build-essential libreadline-dev libssl-dev zlib1g-dev libyaml-dev libxml2-dev libxslt-dev 

sudo apt-get install -y \
  libgdbm-dev libffi-dev

test -d ~/.rbenv || \
  git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv

test -d /home/vagrant/.rbenv/plugins/ruby-build || \
  git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build

# zsh knowns about rbenv by plugin
source ~/.zshrc

#rbenv versions | grep 2.1.5 || 
rbenv install 2.1.5 --verbose

rbenv global 2.1.5

rbenv version
rbenv rehash
ruby -v
gem list | grep bundler || gem install bundler

rbenv rehash

exit 0;
