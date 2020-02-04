#!/bin/bash -e

install -m 644 files/extra.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

on_chroot apt-key add - < files/oss.boating.gpg.key
on_chroot apt-key add - < files/open-mind.space.gpg.key

on_chroot << EOF
apt-get update
EOF
