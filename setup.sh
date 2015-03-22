#!/usr/bin/env sh

bundle

vagrant plugin install vagrant-ansible-local
vagrant plugin install vagrant-plugin-bundler
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-faster
vagrant plugin install vagrant-scp
vagrant plugin install vagrant-cachier
