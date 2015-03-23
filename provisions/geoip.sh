#!/bin/bash

wget --no-verbose -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip GeoLiteCity.dat.gz

test -d /usr/share/GeoIP || mkdir /usr/share/GeoIP
mv GeoLiteCity.dat /usr/share/GeoIP/

# В 14.04LTS нет пакета geoip-database-contrib
# а этот не преоставляет GeoLiteCity
#sudo apt-get install geoip-bin
