#!/bin/bash -e

#install sk
on_chroot << EOF
npm install --verbose -g --unsafe-perm signalk-server
EOF

