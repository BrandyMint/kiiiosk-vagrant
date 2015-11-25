#!/bin/bash

set -o errexit
set -o xtrace

export DEBIAN_FRONTEND=noninteractive;

apt-get update
#apt-get upgrade -y

# mdbtools mdbtools-dev 
 
apt-get -y install software-properties-common ca-certificates lsb-release openssl python-dev python-pip apt-transport-https
# Install dtrace
apt-get -y install systemtap-sdt-dev

apt-get -y install git htop mc dsh

#apt-get -y install libnotify-bin

# Programming tools
apt-get -y install vim-nox exuberant-ctags silversearcher-ag

apt-get -y remove puppet-common chef-zero

apt-get -y install libmysqlclient-dev
# apt-get -y install sqlite3 libsqlite3-dev 

test -f /etc/ssh/ssh_known_hosts && \
  grep "`ssh-keyscan -t rsa github.com`" /etc/ssh/ssh_known_hosts || \
  ssh-keyscan -t rsa github.com |tee /etc/ssh/ssh_known_hosts

test -f /etc/sudoers.d/ssh || \
  echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/ssh


tee /home/vagrant/.ssh/config > /dev/null 2>&1 <<EOF
Host *
  ForwardAgent yes
EOF

exit 0;
