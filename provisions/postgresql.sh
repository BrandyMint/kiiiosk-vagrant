#!/bin/bash

wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
add-apt-repository -y 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main'
apt-get update

apt-get -y install libpq-dev zsh postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 \
  && echo 'OK' || true;

tee /etc/postgresql/9.4/main/pg_hba.conf > /dev/null 2>&1 <<EOF
local   all             postgres                                trust
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
EOF

service postgresql restart;

createuser vagrant -U postgres -s

exit 0;
