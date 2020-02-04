#!/bin/bash -e

install -m 644 files/can0 "${ROOTFS_DIR}/etc/network/interfaces.d/"

on_chroot << EOF
systemctl daemon-reload
systemctl enable canboat.service
EOF

