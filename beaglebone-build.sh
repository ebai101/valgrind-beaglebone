#!/bin/sh

if [ -e /usr/bin/arm-linux-gnueabi-gcc ]
	# if using gcc-arm-linux-gnueabi from Ubuntu sources
	export CROSS_COMPILE=arm-linux-gnueabi-
else
	# if using sourcery codebench lite
	export PATH=/home/vagrant/arm-2014.05/bin:$PATH
	export CROSS_COMPILE=arm-none-linux-gnueabi-
fi

export CC=${CROSS_COMPILE}gcc
export CPP=${CROSS_COMPILE}cpp
export CXX=${CROSS_COMPILE}g++
export LD=${CROSS_COMPILE}ld
export AR=${CROSS_COMPILE}ar


if [ -e /usr/bin/arm-linux-gnueabi-gcc ]
	# if using gcc-arm-linux-gnueabi from Ubuntu sources
	./configure --target=arm-linux-gnueabi --host=armv7-none-linux-gnueabi --prefix=/opt/valgrind CFLAGS=-static
else
	# if using sourcery codebench lite
	./configure --target=arm-none-linux-gnueabi --host=armv7-none-linux-gnueabi --prefix=/opt/valgrind CFLAGS=-static
fi

make
sudo make install
