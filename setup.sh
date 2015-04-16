#!/usr/bin/env sh

ssh-add ~/.ssh/id_rsa

mkdir ./code

#bundle

vagrant plugin install vagrant-ansible-local
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-faster
vagrant plugin install vagrant-scp
vagrant plugin install vagrant-cachier

#vagrant plugin install vagrant-plugin-bundler
#config.plugin.deps do
  ##depend 'vagrant-omnibus', '1.0.2'
#end
#config.plugin.depend 'vagrant-omnibus', '1.0.2'
