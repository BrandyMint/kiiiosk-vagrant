export DEBIAN_FRONTEND=noninteractive;
apt-get -y install graphite-web graphite-carbon libpq-dev python-psycopg2 apache2 libapache2-mod-wsgi
a2dissite 000-default

psql -c "CREATE USER graphite WITH PASSWORD 'graphitepasswd';" -U postgres -q
psql -c "CREATE DATABASE graphite WITH OWNER graphite;" -U postgres -q

echo 'Configure /etc/graphite/local_settings.py'
tee /etc/graphite/local_settings.py > /dev/null 2>&1 <<EOF
SECRET_KEY = 'FGnfgnfkgnkj4i54orfjKtn4rofjnoNFg4rmflnF$rflnGHGGHGHGNKNDKRJKWEkdmnfgjbnfjkelasmn5465ei695euti'
TIME_ZONE = 'Europe/Moscow'
LOG_RENDERING_PERFORMANCE = True
LOG_CACHE_PERFORMANCE = True
LOG_METRIC_ACCESS = True
GRAPHITE_ROOT = '/usr/share/graphite-web'
CONF_DIR = '/etc/graphite'
STORAGE_DIR = '/var/lib/graphite/whisper'
CONTENT_DIR = '/usr/share/graphite-web/static'
WHISPER_DIR = '/var/lib/graphite/whisper'
LOG_DIR = '/var/log/graphite'
INDEX_FILE = '/var/lib/graphite/search_index'  # Search index file
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'localhost'
EMAIL_PORT = 25
EMAIL_USE_TLS = False
USE_REMOTE_USER_AUTHENTICATION = True
DATABASES = {
    'default': {
        'NAME': 'graphite',
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'USER': 'graphite',
        'PASSWORD': 'graphitepasswd',
        'HOST': 'localhost',
        'PORT': '5432'
    }
}
EOF
echo 'configure /etc/default/graphite-carbon'
tee /etc/default/graphite-carbon > /dev/null 2>&1 <<EOF
CARBON_CACHE_ENABLED=true
EOF

test -f /etc/graphite/syncdb.lock || echo 'running graphite-manage syncdb' && graphite-manage syncdb --noinput && touch /etc/graphite/syncdb.lock
test -f /etc/graphite/syncdb.lock || echo 'create superuser' && echo "from django.contrib.auth.models import User; User.objects.create_superuser('vagrant', 'vagrant@localhost', 'vagrant')" | graphite-manage shell && touch /etc/graphite/syncdb.lock
echo 'configure /etc/carbon/carbon.conf'
tee /etc/carbon/carbon.conf > /dev/null 2>&1 <<EOF
[cache]
STORAGE_DIR    = /var/lib/graphite/
CONF_DIR       = /etc/carbon/
LOG_DIR        = /var/log/carbon/
PID_DIR        = /var/run/
LOCAL_DATA_DIR = /var/lib/graphite/whisper/
ENABLE_LOGROTATION = True
USER = _graphite
MAX_CACHE_SIZE = inf
MAX_UPDATES_PER_SECOND = 500
MAX_CREATES_PER_MINUTE = 50
LINE_RECEIVER_INTERFACE = 0.0.0.0
LINE_RECEIVER_PORT = 2003
ENABLE_UDP_LISTENER = False
UDP_RECEIVER_INTERFACE = 0.0.0.0
UDP_RECEIVER_PORT = 2003
PICKLE_RECEIVER_INTERFACE = 0.0.0.0
PICKLE_RECEIVER_PORT = 2004
LOG_LISTENER_CONNECTIONS = True
USE_INSECURE_UNPICKLER = False
CACHE_QUERY_INTERFACE = 0.0.0.0
CACHE_QUERY_PORT = 7002
USE_FLOW_CONTROL = True
LOG_UPDATES = False
LOG_CACHE_HITS = False
LOG_CACHE_QUEUE_SORTS = True
CACHE_WRITE_STRATEGY = sorted
WHISPER_AUTOFLUSH = False
WHISPER_FALLOCATE_CREATE = True
[relay]
LINE_RECEIVER_INTERFACE = 0.0.0.0
LINE_RECEIVER_PORT = 2013
PICKLE_RECEIVER_INTERFACE = 0.0.0.0
PICKLE_RECEIVER_PORT = 2014
LOG_LISTENER_CONNECTIONS = True
RELAY_METHOD = rules
REPLICATION_FACTOR = 1
DESTINATIONS = 127.0.0.1:2004
MAX_DATAPOINTS_PER_MESSAGE = 500
MAX_QUEUE_SIZE = 10000
USE_FLOW_CONTROL = True
[aggregator]
LINE_RECEIVER_INTERFACE = 0.0.0.0
LINE_RECEIVER_PORT = 2023
PICKLE_RECEIVER_INTERFACE = 0.0.0.0
PICKLE_RECEIVER_PORT = 2024
LOG_LISTENER_CONNECTIONS = True
FORWARD_ALL = True
DESTINATIONS = 127.0.0.1:2004
REPLICATION_FACTOR = 1
MAX_QUEUE_SIZE = 10000
USE_FLOW_CONTROL = True
MAX_DATAPOINTS_PER_MESSAGE = 500
MAX_AGGREGATION_INTERVALS = 5
EOF
echo 'configure /etc/carbon/storage-schemas.conf'
tee /etc/carbon/storage-schemas.conf > /dev/null 2>&1 <<EOF

[carbon]
pattern = ^carbon\.
retentions = 60:90d

[default_1min_for_1day]
pattern = .*
retentions = 1m:1d

[test]
pattern = ^test\.
retentions = 10s:10m,1m:1h,10m:1d

[statsd]
pattern = ^stats.*
retentions = 10s:1d,1m:7d,10m:1y
EOF

echo 'configure /etc/carbon/storage-aggregation.conf'
tee /etc/carbon/storage-aggregation.conf > /dev/null 2>&1 <<EOF

[min]
pattern = \.min$
xFilesFactor = 0.1
aggregationMethod = min

[max]
pattern = \.max$
xFilesFactor = 0.1
aggregationMethod = max

[count]
pattern = \.count$
xFilesFactor = 0
aggregationMethod = sum

[lower]
pattern = \.lower(_\d+)?$
xFilesFactor = 0.1
aggregationMethod = min

[upper]
pattern = \.upper(_\d+)?$
xFilesFactor = 0.1
aggregationMethod = max

[sum]
pattern = \.sum$
xFilesFactor = 0
aggregationMethod = sum

[gauges]
pattern = ^.*\.gauges\..*
xFilesFactor = 0
aggregationMethod = last

[default_average]
pattern = .*
xFilesFactor = 0.5
aggregationMethod = average
EOF

tee /etc/apache2/sites-enabled/graphite.conf > /dev/null 2>&1 <<EOF
Listen *:8023
<VirtualHost *:8023>

        WSGIDaemonProcess _graphite processes=5 threads=5 display-name='%{GROUP}' inactivity-timeout=120 user=_graphite group=_graphite
        WSGIProcessGroup _graphite
        WSGIImportScript /usr/share/graphite-web/graphite.wsgi process-group=_graphite application-group=%{GLOBAL}
        WSGIScriptAlias / /usr/share/graphite-web/graphite.wsgi

        Alias /content/ /usr/share/graphite-web/static/
        <Location "/content/">
                SetHandler None
        </Location>

        ErrorLog ${APACHE_LOG_DIR}/graphite-web_error.log

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn

        CustomLog ${APACHE_LOG_DIR}/graphite-web_access.log combined

</VirtualHost>
EOF
service apache2 restart
