#!/bin/bash -e

cat files/figlet >> ${ROOTFS_DIR}/etc/motd

on_chroot << EOF
systemctl daemon-reload
systemctl disable hostapd.service
systemctl disable gpsd.socket gpsd.service
systemctl disable ntp.service
apt install -y avnav avnav-raspi
EOF

