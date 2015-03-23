#!/bin/bash

set -o errexit
set -o xtrace

if tmux -V | grep 1.9a; then
  echo "Tmux 1.9a is already installed"
  exit 0
fi

sudo apt-get -y install libevent-dev libghc-ncurses-dev

# Instal Tmux 1.9
wget http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.9/tmux-1.9a.tar.gz

tar -zxf tmux-1.9a.tar.gz 
cd tmux-1.9a
./configure && make && sudo make install



# Tmux plugins
mkdir ~/.tmux && mkdir ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

exit 0
