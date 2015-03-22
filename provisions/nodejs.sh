#!/bin/bash

apt-get -y install nodejs nodejs-legacy npm && echo 'OK' || true;

npm install -g bower;

exit 0;
