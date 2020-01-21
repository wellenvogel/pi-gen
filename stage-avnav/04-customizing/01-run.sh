#!/bin/bash -e

on_chroot << EOF
echo "set mouse-=a" >> /home/pi/.vimrc
echo "set mouse-=a" >> /root/.vimrc
echo "#dtparam=spi=on" >> /boot/config.txt
echo "#dtoverlay=mcp2515-can0,oscillator=8000000,interrupt=25,spimaxfrequency=1000000" >> /boot/config.txt
EOF
