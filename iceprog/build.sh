#!/bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

unset CFLAGS
unset CXXFLAGS
unset CPPFLAGS
unset DEBUG_CXXFLAGS
unset DEBUG_CPPFLAGS
unset LDFLAGS


case $(uname -m) in
i386|x86_64)
	export HOST_ARCH="x86_64"
;;
arm64|aarch64)
	export HOST_ARCH="aarch64"
;;
esac

INCLUDES="$(PKG_CONFIG_PATH=/usr/lib/${HOST_ARCH}-linux-gnu/pkgconfig pkg-config --dont-define-prefix --cflags libftdi1 libusb libudev)"
INCLUDES='-I/usr/include/libftdi1 -I/usr/include/libusb-1.0'
STATIC_LIBS="$(PKG_CONFIG_PATH=/usr/lib/${HOST_ARCH}-linux-gnu/pkgconfig pkg-config --dont-define-prefix --libs libftdi1 libusb)"
STATIC_LIBS="-L/usr/lib/${HOST_ARCH}-linux-gnu -lftdi1 -lusb-1.0 -lusb"
DYNAMIC_LIBS="$(PKG_CONFIG_PATH=/usr/lib/${HOST_ARCH}-linux-gnu/pkgconfig pkg-config --dont-define-prefix --libs libudev)"
DYNAMIC_LIBS="-L/lib/${HOST_ARCH}-linux-gnu -ludev"

export CFLAGS="$CFLAGS $INCLUDES"
export LDFLAGS="$LDFLAGS -lm -lstdc++ -lpthread -Wl,--whole-archive -Wl,-Bstatic $STATIC_LIBS -Wl,-Bdynamic -Wl,--no-whole-archive $DYNAMIC_LIBS"

make -j$CPU_COUNT

make install

iceprog -h
