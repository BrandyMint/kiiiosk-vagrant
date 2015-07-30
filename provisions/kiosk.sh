#!/usr/bin/zsh
export RBENV_ROOT=/home/vagrant/.rbenv
export PATH=${RBENV_ROOT}/bin:$PATH

test -d /home/vagrant/code/kiiiosk.dev || \
  git clone -b develop git@github.com:BrandyMint/merchantly.git /home/vagrant/code/kiiiosk.dev

cp /home/vagrant/code/kiiiosk.dev/config/database.yml.vexor /home/vagrant/code/kiiiosk.dev/config/database.yml
cd /home/vagrant/code/kiiiosk.dev && rbenv exec gem install bundler

cd /home/vagrant/code/kiiiosk.dev && ./scripts/setup.sh

exit 0
