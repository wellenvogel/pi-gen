#!/bin/bash -e

on_chroot << EOF
echo "set mouse-=a" >> /home/pi/.vimrc
echo "set mouse-=a" >> /root/.vimrc
EOF
