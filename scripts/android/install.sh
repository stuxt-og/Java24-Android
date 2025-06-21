#!/usr/bin/bash
# $1 - arch for apt
set -u

echo "http://ports.ubuntu.com/ubuntu-ports/" | sudo tee -a /etc/apt/apt-mirrors.txt

sudo dpkg --add-architecture $1

sudo apt-get update

sudo apt-get install --only-upgrade apt

mkdir debtemp

cd debtemp

apt download libxrandr-dev:$1 libxtst-dev:$1 libcups2-dev:$1 libasound2-dev:$1 libfontconfig-dev:$1

cd ..

echo "Downloading NDK"
wget -nc -nv -O android-ndk.zip "https://dl.google.com/android/repository/android-ndk-r27b-linux.zip"

unzip -q android-ndk.zip

for file in debtemp/*.deb; do
	dpkg-deb -x $file $SYSROOT
done

export BUILD_FREETYPE_VERSION="2.10.0"

wget https://downloads.sourceforge.net/project/freetype/freetype2/$BUILD_FREETYPE_VERSION/freetype-$BUILD_FREETYPE_VERSION.tar.gz
tar xf freetype-$BUILD_FREETYPE_VERSION.tar.gz
rm freetype-$BUILD_FREETYPE_VERSION.tar.gz

cd freetype-$BUILD_FREETYPE_VERSION

echo "Building Freetype"

export PATH=$TOOLCHAIN/bin:$PATH
  ./configure \
    --host=$TARGET \
    --prefix=$SYSROOT \
    --without-zlib \
    --with-png=no \
    --with-harfbuzz=no \
    || error_code=$?

if [[ "$error_code" -ne 0 ]]; then
  echo "\n\nCONFIGURE ERROR $error_code, config.log:"
  cat ${PWD}/builds/unix/config.log
  exit $error_code
fi

CFLAGS=-fno-rtti CXXFLAGS=-fno-rtti make -j$(nproc)
make install

cd ..
