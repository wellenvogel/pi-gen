#!/bin/bash -e

on_chroot << EOF
systemctl daemon-reload
systemctl disable n2kd.service
EOF

