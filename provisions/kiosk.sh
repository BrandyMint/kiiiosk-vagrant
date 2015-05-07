#!/usr/bin/zsh

test -d /home/vagrant/code/kiiiosk.dev || \
  git clone -b develop git@github.com:BrandyMint/merchantly.git /home/vagrant/code/kiiiosk.dev

cd /home/vagrant/code/kiiiosk.dev

./scripts/setup.sh

exit 0
