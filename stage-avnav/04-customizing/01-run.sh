#!/bin/bash -e

install -m 775 -o 1000 -g 1000 files/uart_control "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

on_chroot << EOF
echo "set mouse-=a" >> /home/pi/.vimrc
echo "set mouse-=a" >> /root/.vimrc
echo "#dtparam=spi=on" >> /boot/config.txt
echo "#dtoverlay=mcp2515-can0,oscillator=8000000,interrupt=25,spimaxfrequency=1000000" >> /boot/config.txt
EOF
