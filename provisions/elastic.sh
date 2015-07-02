#!/bin/bash

set -o errexit
set -o xtrace
echo 'Running elastic.sh'
# JDK

add-apt-repository -y ppa:webupd8team/java;
apt-get update

echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections;

apt-get -y install oracle-java7-installer 


# Elastic
#

# ==> kiiiosk: W: GPG error: http://packages.elasticsearch.org stable Release: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY D27D666CD88E42B4
wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
add-apt-repository -y 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main';
apt-get update && apt-get -y install elasticsearch
update-rc.d elasticsearch defaults 95 10;
service elasticsearch start
# Попробую пока без него, вроде должно и так работать.
/usr/share/elasticsearch/bin/plugin -l|grep analysis-morphology || /usr/share/elasticsearch/bin/plugin -install analysis-morphology -url http://dl.bintray.com/content/imotov/elasticsearch-plugins/org/elasticsearch/elasticsearch-analysis-morphology/1.2.0/elasticsearch-analysis-morphology-1.2.0.zip;

/usr/share/elasticsearch/bin/plugin -l|grep HQ || /usr/share/elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ;

exit 0;
