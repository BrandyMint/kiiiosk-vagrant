#!/bin/bash


export DEBIAN_FRONTEND=noninteractive

apt-get -y install libtomcat7-java tomcat7 tomcat7-admin tomcat7-common

cp /home/vagrant/vagrant/files/default/tomcat7 /etc/default/tomcat7
usermod -a -G tomcat7 vagrant

mkdir -p /home/vagrant/code/kiiiosk-open-api/webapps
chown vagrant:vagrant -R /home/vagrant/code/kiiiosk-open-api/webapps
rm -rvf /etc/tomcat7 && cp -a /home/vagrant/vagrant/files/tomcat7 /etc/tomcat7

service tomcat7 restart
