#!/bin/bash

set -o errexit
set -o xtrace

export DEBIAN_FRONTEND=noninteractive;

apt-get update
#apt-get upgrade -y

# mdbtools mdbtools-dev 
 
apt-get -y install software-properties-common ca-certificates lsb-release openssl

# Install dtrace
apt-get -y install systemtap-sdt-dev

apt-get -y install git htop mc 

#apt-get -y install libnotify-bin

# Programming tools
apt-get -y install vim-nox exuberant-ctags silversearcher-ag

# libmysqlclient-dev 
# apt-get -y install sqlite3 libsqlite3-dev 

test -f /etc/ssh/ssh_known_hosts && \
  grep "`ssh-keyscan -t rsa github.com`" /etc/ssh/ssh_known_hosts || \
  ssh-keyscan -t rsa github.com |tee /etc/ssh/ssh_known_hosts

test -f /etc/sudoers.d/ssh || \
  echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/ssh

exit 0;
