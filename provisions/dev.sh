#!/usr/bin/zsh
echo 'Running dev.sh'
source ~/.zshrc
# Fix dpkg-preconfigure: unable to re-open stdin: No such file or directory

export DEBIAN_FRONTEND=noninteractive

apt-get -y install libmagickwand-dev imagemagick 

apt-get -y install memcached redis-server 

test -d /home/vagrant/code || sudo -u vagrant mkdir /home/vagrant/code

# https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p

exit 0
