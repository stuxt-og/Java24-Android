#!/usr/bin/bash
# $1 - bootjdk path

set -e

bash configure \
	--with-conf-name=$TARGET \
	--openjdk-target=$TARGET \
	--with-boot-jdk=$1 \
	--with-zlib=system \
	--with-jmod-compress=zip-1 \
	--with-version-opt=fastdebug \
	--with-gtest= \
	--enable-headless-only \
	--with-jvm-variants=$JVM_VARIANTS \
	--enable-dtrace=no \
	--with-jvm-features= \
	--disable-precompiled-headers \
	--with-toolchain-type=clang \
	CC=$thecc \
	CXX=$thecxx \
	AR=$TOOLCHAIN/bin/llvm-ar \
	AS=$TOOLCHAIN/bin/llvm-as \
	LD=$TOOLCHAIN/bin/ld \
	OBJCOPY=$TOOLCHAIN/bin/llvm-objcopy \
	RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
	STRIP=$TOOLCHAIN/bin/llvm-strip \
	|| ( \
	echo "Dumping config.log:" && \
	cat config.log && \
	exit 1)
