export DEBIAN_FRONTEND=noninteractive;

apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
echo "deb http://repo.percona.com/apt "$(lsb_release -sc)" main" | sudo tee /etc/apt/sources.list.d/percona.list

apt-get update
apt-get -y install percona-server-server-5.6
