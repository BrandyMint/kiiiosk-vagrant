#!/bin/bash

set -o errexit
set -o xtrace

sudo apt-get -y install zsh

git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
sudo chsh -s $(which zsh) $USER

echo "Install dotfiles"
git clone https://github.com/dapi/dotfiles.git

./dotfiles/install.sh
./dotfiles/vim_setup.sh

exit 0
