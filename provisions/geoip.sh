#!/bin/bash

wget --no-verbose -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip GeoLiteCity.dat.gz

mkdir /usr/local/share/GeoIP
mv GeoLiteCity.dat /usr/local/share/GeoIP/

# В 14.04LTS нет пакета geoip-database-contrib
# а этот не преоставляет GeoLiteCity
#sudo apt-get install geoip-bin
