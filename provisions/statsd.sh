export DEBIAN_FRONTEND=noninteractive;
apt-get -y install git nodejs devscripts debhelper
git clone https://github.com/etsy/statsd.git
cd statsd && dpkg-buildpackage && cd .. && dpkg -i statsd*.deb
tee /etc/statsd/localConfig.js > /dev/null 2>&1 <<EOF
{
  graphitePort: 2003
, graphiteHost: "localhost"
, port: 8125
, graphite: {
    legacyNamespace: false
  }
}
EOF
sudo service carbon-cache stop 
sleep 3
sudo service carbon-cache start
sudo service statsd restart
