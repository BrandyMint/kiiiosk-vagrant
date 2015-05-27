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

cp /home/vagrant/vagrant/files/upstart/thumbor.conf /etc/init/thumbor.conf
cp /home/vagrant/vagrant/files/upstart/thumbor-worker.conf /etc/init/thumbor-worker.conf

restart thumbor || start thumbor
