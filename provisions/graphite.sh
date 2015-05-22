export DEBIAN_FRONTEND=noninteractive;
apt-get -y install graphite-web graphite-carbon libpq-dev python-psycopg2 apache2 libapache2-mod-wsgi
a2dissite 000-default

psql -c "CREATE USER graphite WITH PASSWORD 'graphitepasswd';" -U postgres -q
psql -c "CREATE DATABASE graphite WITH OWNER graphite;" -U postgres -q
echo 'running graphite.sh'
echo 'Configure /etc/graphite/local_settings.py'
cp /home/vagrant/vagrant/files/graphite-local_settings.py /etc/graphite/local_settings.py
echo 'configure /etc/default/graphite-carbon'
tee /etc/default/graphite-carbon > /dev/null 2>&1 <<EOF
CARBON_CACHE_ENABLED=true
EOF

test -f /etc/graphite/syncdb.lock || echo 'running graphite-manage syncdb' && graphite-manage syncdb --noinput && touch /etc/graphite/syncdb.lock
test -f /etc/graphite/syncdb.lock || echo 'create superuser' && echo "from django.contrib.auth.models import User; User.objects.create_superuser('vagrant', 'vagrant@localhost', 'vagrant')" | graphite-manage shell && touch /etc/graphite/syncdb.lock
echo 'configure /etc/carbon/carbon.conf'
cp /home/vagrant/vagrant/files/carbon.conf /etc/carbon/carbon.conf

echo 'configure /etc/carbon/storage-schemas.conf'
cp /home/vagrant/vagrant/files/storage-schemas.conf /etc/carbon/storage-schemas.conf

echo 'configure /etc/carbon/storage-aggregation.conf'
cp /home/vagrant/vagrant/files/storage-aggregation.conf /etc/carbon/storage-aggregation.conf

cp /home/vagrant/vagrant/files/apache2.conf /etc/apache2/sites-enabled/graphite.conf

service apache2 restart
