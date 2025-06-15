#!/usr/bin/bash

source scripts/android/setup_env.sh

export TARGET=armv7a-linux-androideabi

export CFLAGS="-I$ANDROID_INCLUDE -I$ANDROID_INCLUDE/$TARGET -mllvm -polly -DANDROID -Wno-error=implicit-function-declaration -Wno-error=int-conversion -DLE_STANDALONE -O3 -D__thumb__"
export CPPFLAGS=$CFLAGS
export LDFLAGS="--sysroot=$SYSROOT -L$SYSROOT/usr/lib -L$PWD/dummy_libs -Wl,--undefined-version"

# Configure and build.
ln -sf "$thecc" "$TOOLCHAIN/tbin/clang"
ln -sf "$thecxx" "$TOOLCHAIN/tbin/clang++"
ln -sf "$TOOLCHAIN/bin/llvm-ar" "$TOOLCHAIN/tbin/llvm-ar"
ln -sf "$TOOLCHAIN/bin/llvm-as" "$TOOLCHAIN/tbin/llvm-as"
ln -sf "$TOOLCHAIN/bin/ld" "$TOOLCHAIN/tbin/ld"
ln -sf "$TOOLCHAIN/bin/objcopy" "$TOOLCHAIN/tbin/objcopy"
ln -sf "$TOOLCHAIN/bin/ranlib" "$TOOLCHAIN/tbin/ranlib"
ln -sf "$TOOLCHAIN/bin/strip" "$TOOLCHAIN/tbin/strip"

export ANDROID_INCLUDE=$SYSROOT/usr/include

# Create dummy libraries so we won't have to remove them in OpenJDK makefiles
mkdir -p dummy_libs
ar cru dummy_libs/libpthread.a
ar cru dummy_libs/librt.a
ar cru dummy_libs/libthread_db.a

bash configure \
	--with-conf-name=$TARGET \
	--openjdk-target=$TARGET \
	--with-boot-jdk=$1 \
	--with-extra-cflags="$CFLAGS" \
	--with-extra-cxxflags="$CXXFLAGS" \
	--with-extra-ldflags="$LDFLAGS" \
	--with-zlib=system \
	--with-jmod-compress=zip-1 \
	--with-version-opt=$2 \
	--with-gtest= \
	--enable-headless-only \
	--disable-warnings-as-errors \
	--x-includes=$ANDROID_INCLUDE \
	--enable-option-checking=fatal \
	--with-jvm-variants=client \
	--with-jvm-features=-dtrace,-zero,-vm-structs,-epsilongc \
	--with-devkit=$TOOLCHAIN \
	--with-native-debug-symbols=external \
	--disable-precompiled-headers \
	--with-fontconfig-include=$ANDROID_INCLUDE \
	--x-libraries=$SYSROOT/usr/lib \
	--with-cups-include=$ANDROID_INCLUDE \
	--with-toolchain-type=clang \
	--with-tools-dir=$TOOLCHAIN/tbin \
	--with-cups-include=$CUPS_DIR || ( \
	echo "Dumping config.log:" && \
	cat config.log && \
	exit 1)
