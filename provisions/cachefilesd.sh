#!/bin/bash
echo 'Running cachefilesd.sh'

set -o errexit
set -o xtrace

# http://chase-seibert.github.io/blog/2014/03/09/vagrant-cachefilesd.html
sudo apt-get install cachefilesd
sudo echo "RUN=yes" > /etc/default/cachefilesd
