apt-get -y install gifsicle python-opencv
pip install thumbor
useradd -m -d /var/lib/thumbor -s /bin/sh thumbor

tee /etc/default/thumbor > /dev/null 2>&1 <<EOF
enabled=1
conffile=/etc/thumbor.conf
port=8081
ip=0.0.0.0
EOF

tee /etc/thumbor.key > /dev/null 2>&1 <<EOF
d41d8cd98f00b204e9800998ecf8427e
golobog
EOF

tee /etc/thumbor.conf > /dev/null 2>&1 <<EOF
ALLOWED_SOURCES =     ['.+']
QUALITY = 85
ALLOW_ANIMATED_GIFS = True
LOADER = 'thumbor.loaders.http_loader'
USE_GIFSICLE_ENGINE = True
SECURITY_KEY = 'golobog'
ALLOW_UNSAFE_URL = True
ALLOW_OLD_URLS = True
STORES_CRYPTO_KEY_FOR_EACH_IMAGE = True
FILE_STORAGE_ROOT_PATH = '/tmp/thumbor/storage'
DETECTORS =     [
'thumbor.detectors.face_detector',
'thumbor.detectors.feature_detector',
'thumbor.detectors.feature_detector',
'thumbor.detectors.glasses_detector',
'thumbor.detectors.profile_detector'
    ]
RESULT_STORAGE_FILE_STORAGE_ROOT_PATH = '/tmp/thumbor/result_storage'
EOF

tee /etc/init/thumbor.conf > /dev/null 2>&1 <<EOF
description "Thumbor image manipulation service"
author "Wichert Akkerman <wichert@wiggy.net>"

start on filesystem and runlevel [2345]
stop on runlevel [!2345]

console output

env port=80

pre-start script
    [ -r /etc/default/thumbor ] && . /etc/default/thumbor
    if [ "$enabled" = "0" ] && [ "$force" != "1" ] ; then
        logger -is -t "$UPSTART_JOB" "Thumbor is disabled by /etc/default/thumbor, add force=1 to your service command"
        stop
        exit 0
    fi
    for p in `echo ${port} | tr ',' ' '`; do
        start thumbor-worker p=$p
    done
end script
EOF


tee /etc/init/thumbor-worker.conf > /dev/null 2>&1 <<EOF
description "Thumbor image manipulation service"
author "Wichert Akkerman <wichert@wiggy.net>"

stop on stopping thumbor

respawn
respawn limit 5 10
umask 022

setuid thumbor
setgid thumbor

env DAEMON=/usr/local/bin/thumbor

env conffile=/etc/thumbor.conf
env keyfile=/etc/thumbor.key
env ip=0.0.0.0

chdir /var/lib/thumbor

instance "$p"

pre-start script
    [ -r /etc/default/thumbor ] && . /etc/default/thumbor
    if [ "$enabled" = "0" ] && [ "$force" != "1" ] ; then
        logger -is -t "$UPSTART_JOB" "Thumbor is disabled by /etc/default/thumbor, add force=1 to your service command"
        stop
        exit 0
    fi
    exec >"/tmp/${UPSTART_JOB}-${p}"
    echo "ip=${ip}"
end script

script
    . "/tmp/${UPSTART_JOB}-${p}"
    $DAEMON -c "${conffile}" -i "${ip}" -k "${keyfile}" -p "${p}" -l debug
end script

post-start script
    rm -f "/tmp/$UPSTART_JOB-${p}"
end script
EOF

restart thumbor || start thumbor
