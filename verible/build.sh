#! /bin/bash

set -e
set -x

case $(uname -m) in
i386|x86_64)
	export HOST_ARCH="x86_64"
;;
arm64|aarch64)
	export HOST_ARCH="aarch64"
;;
esac

export CC=gcc-${USE_SYSTEM_GCC_VERSION}
export CXX=g++-${USE_SYSTEM_GCC_VERSION}


mkdir bazel-install
BAZEL_PREFIX=$PWD/bazel-install


wget https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel-3.7.2-installer-linux-${HOST_ARCH}.sh
chmod +x bazel-3.7.2-installer-linux-${HOST_ARCH}.sh
./bazel-3.7.2-installer-linux-${HOST_ARCH}.sh --prefix=$BAZEL_PREFIX

export PATH=$BAZEL_PREFIX/bin:$PATH

bazel run :install -c opt -- $PREFIX/bin
