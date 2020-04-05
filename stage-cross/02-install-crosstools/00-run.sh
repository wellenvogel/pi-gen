#! /bin/sh
apt-get install -y cmake
DIR=/crosstools
TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64
#https://github.com/abhiTronix/raspberry-pi-cross-compilers/wiki/Cross-Compiler:-Installation-Instructions
#BUSTER for 2/3
sum=`md5sum $0 | awk '{print $1;}'`
DLURL="https://downloads.sourceforge.net/project/raspberry-pi-cross-compilers/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Buster/GCC%208.3.0/Raspberry%20Pi%202%2C%203/cross-gcc-8.3.0-pi_2-3.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fraspberry-pi-cross-compilers%2Ffiles%2FRaspberry%2520Pi%2520GCC%2520Cross-Compiler%2520Toolchains%2FBuster%2FGCC%25208.3.0%2FRaspberry%2520Pi%25202%252C%25203%2F&ts=1586085768&use_mirror=iweb"
[ ! -d "$DIR" ] && mkdir -p "$DIR"
if [ -f $DIR/md5 ] ; then
  oldsum=`cat $DIR/md5`
  if [ "$oldsum" = "$sum" ] ; then
    echo "md5sum $DIR/md5 not changed, skip download"
    exit 0
  fi
  echo "md5 differs, old=$oldsum, new=$sum"
fi
cd $DIR && curl -L "$DLURL"  | tar --wildcards -xzf - 
echo "$sum" > $DIR/md5

