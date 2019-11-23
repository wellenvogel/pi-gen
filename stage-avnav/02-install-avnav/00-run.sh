#!/bin/bash -e

install -m 644 files/avnav_20191112_all.deb "${ROOTFS_DIR}/tmp"
install -m 644 files/avnav-raspi_20191027_all.deb "${ROOTFS_DIR}/tmp"

on_chroot << EOF
dpkg -i /tmp/avnav_20191112_all.deb
dpkg -i /tmp/avnav-raspi_20191027_all.deb
systemctl daemon-reload
systemctl disable hostapd.service
systemctl disable gpsd.socket gpsd.service
EOF

