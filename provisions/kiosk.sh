#!/usr/bin/zsh

source ~/.zshrc
# Fix dpkg-preconfigure: unable to re-open stdin: No such file or directory

export DEBIAN_FRONTEND=noninteractive

# Пока нет нужды
# apt-get -y install libmagickwand-dev imagemagick 

sudo apt-get -y install memcached redis-server 

test -d /home/vagrant/code || \
  mkdir /home/vagrant/code

test -d /home/vagrant/code/kiiiosk.dev || \
  git clone -b develop git@github.com:BrandyMint/merchantly.git /home/vagrant/code/kiiiosk.dev

cd /home/vagrant/code/kiiiosk.dev

./scripts/setup.sh

exit 0
