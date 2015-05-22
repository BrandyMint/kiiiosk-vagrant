echo 'Running grafana.sh'
export DEBIAN_FRONTEND=noninteractive;
wget https://grafanarel.s3.amazonaws.com/builds/grafana_2.0.2_amd64.deb -O /tmp/grafana_2.0.2_amd64.deb
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i /tmp/grafana_2.0.2_amd64.deb
sudo update-rc.d grafana-server defaults 95 10
cp /tmp/files/grafana.ini /etc/grafana/grafana.ini


service grafana-server start
