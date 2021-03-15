#! /bin/bash -e

#install mcs-sk plugins
on_chroot << EOF
cd /home/${FIRST_USER_NAME}/.signalk
npm i --verbose signalk-raspberry-mcs
chown -R ${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/.signalk
EOF
