#! /bin/bash

set -e
set -x

export CC=gcc-${USE_SYSTEM_GCC_VERSION}
export CXX=g++-${USE_SYSTEM_GCC_VERSION}

mkdir build && cd build

cmake .. -DSLANG_INCLUDE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release

make

install -D bin/driver $PREFIX/bin/slang-driver
install -D bin/rewriter $PREFIX/bin/slang-rewriter
