#!/usr/bin/bash
source scripts/android/setup_env.sh

sudo apt install autoconf python3 python-is-python3 unzip zip systemtap-sdt-dev

echo "http://ports.ubuntu.com/ubuntu-ports/" | sudo tee -a /etc/apt/apt-mirrors.txt

sudo dpkg --add-architecture $1

mkdir debtemp
cd debtemp

sudo apt update

sudo apt-get install --only-upgrade apt

apt download libxrandr-dev:$1 libxtst-dev:$1 libasound2-dev:$1 libelf-dev:$1 libfontconfig-dev:$1 libx11-dev:$1 libxext-dev:$1 libxrandr-dev:$1 libxrender-dev:$1 libxtst-dev:$1 libxt-dev:$1 libcups2-dev:$1

cd ..

echo "Downloading NDK"

export NDK_VERSION=r27b

wget -nc -nv -O android-ndk-$NDK_VERSION-linux-x86_64.zip "https://dl.google.com/android/repository/android-ndk-$NDK_VERSION-linux.zip"
unzip -q android-ndk-$NDK_VERSION-linux-x86_64.zip

echo $PWD/android-ndk

DIR="${1:-.}"

# Loop through all packages

for file in "debtemp"/*; do
  if [ -f "$file" ]; then
		dpkg-deb -x $file $SYSROOT
  fi
done
ls $SYSROOT/usr/include
cp devkit.info.arm $TOOLCHAIN

export BUILD_FREETYPE_VERSION="2.10.0"

wget https://downloads.sourceforge.net/project/freetype/freetype2/$BUILD_FREETYPE_VERSION/freetype-$BUILD_FREETYPE_VERSION.tar.gz
tar xf freetype-$BUILD_FREETYPE_VERSION.tar.gz
rm freetype-$BUILD_FREETYPE_VERSION.tar.gz

cd freetype-$BUILD_FREETYPE_VERSION

echo "Building Freetype"

export PATH=$TOOLCHAIN/bin:$PATH
./configure \
--host=$TARGET \
--prefix=$SYSROOT/usr \
--without-zlib \
--with-png=no \
--with-harfbuzz=no $EXTRA_ARGS \
|| error_code=$?

if [[ "$error_code" -ne 0 ]]; then
	echo
  echo "CONFIGURE ERROR $error_code, config.log:"
  cat ${PWD}/builds/unix/config.log
  exit $error_code
fi

CFLAGS=-fno-rtti CXXFLAGS=-fno-rtti make -j$(nproc)
make install
