#!/bin/bash

set -o errexit
set -o xtrace

sudo apt-get -y install zsh

test -d /home/vagrant/.oh-my-zsh || git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
sudo chsh -s $(which zsh) $USER

echo "Install dotfiles"
#REPO="git@github.com:dapi/dotfiles.git"

rm -fr /home/vagrant/dotfiles
git clone https://github.com/dapi/dotfiles.git

./dotfiles/install.sh
./dotfiles/vim_setup.sh


sudo wget https://raw.github.com/technomancy/leiningen/stable/bin/lein -O /usr/local/bin/lein
sudo chmod +x /usr/local/bin/lein

exit 0
