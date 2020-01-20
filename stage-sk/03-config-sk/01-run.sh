#!/bin/bash -e

#config sk
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk"
install -m 644 -o 1000 -g 1000 files/package.json "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"
install -m 644 -o 1000 -g 1000 files/settings.json "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"
install -m 775 -o 1000 -g 1000 files/signalk-server "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"

#autorun sk
install -m 644 files/signalk.socket  "${ROOTFS_DIR}/etc/systemd/system/"
install -m 644 files/signalk.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
systemctl daemon-reload
systemctl enable signalk.service
systemctl enable signalk.socket
EOF

#install sk plugins
on_chroot << EOF
cd /home/${FIRST_USER_NAME}/.signalk
npm i --verbose signalk-to-nmea2000
npm i --verbose signalk-n2kais-to-nmea0183
chown -R ${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/.signalk
EOF
