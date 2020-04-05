#! /bin/sh
DIR=/crosstools
TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64
[ ! -d "$DIR" ] && mkdir -p "$DIR"
cd $DIR && curl -L https://github.com/raspberrypi/tools/tarball/master  | tar --wildcards --strip-components 3 -xzf - "*/arm-bcm2708/$TOOLCHAIN/"

