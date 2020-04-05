#! /bin/sh
#add opencpn repo
grep opencpn /etc/apt/sources.list > /dev/null || echo 'deb [allow-insecure=yes] http://ppa.launchpad.net/opencpn/opencpn/ubuntu bionic main' >> /etc/apt/sources.list
apt-get update
apt-get install -y --allow-unauthenticated oesenc-pi

