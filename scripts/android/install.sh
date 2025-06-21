#!/usr/bin/bash
# $1 - arch for apt
set -u

echo "http://ports.ubuntu.com/ubuntu-ports/" | sudo tee -a /etc/apt/apt-mirrors.txt

sudo dpkg --add-architecture $1

sudo apt-get update

sudo apt-get install --only-upgrade apt

mkdir debtemp

cd debtemp

apt download libxrandr-dev:$1 libxtst-dev:$1 libasound2-dev:$1 libfontconfig-dev:$1 libusb-1.0-0-dev:$1 

cd ..

echo "Downloading NDK"
wget -nc -nv -O android-ndk.zip "https://dl.google.com/android/repository/android-ndk-r27b-linux.zip"

unzip -q android-ndk.zip

for file in debtemp/*.deb; do
	dpkg-deb -x $file $SYSROOT
done

export BUILD_FREETYPE_VERSION="2.10.0"

wget https://downloads.sourceforge.net/project/freetype/freetype2/$BUILD_FREETYPE_VERSION/freetype-$BUILD_FREETYPE_VERSION.tar.gz >> /dev/null

tar xf freetype-$BUILD_FREETYPE_VERSION.tar.gz

cd freetype-$BUILD_FREETYPE_VERSION

echo "Building Freetype"

error_code=0

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

wget https://github.com/apple/cups/releases/download/v2.2.4/cups-2.2.4-source.tar.gz >> /dev/null
tar xf cups-2.2.4-source.tar.gz

rm cups-2.2.4-source.tar.gz freetype-$BUILD_FREETYPE_VERSION.tar.gz

cd cups-2.2.4

bash ./configure \
  --host=$TARGET \
  --prefix=$SYSROOT \
  --disable-shared \
  --enable-static \
  --disable-gssapi \
  --disable-dbus \
  --disable-avahi \
  --disable-systemd \
  --disable-launchd \
  --disable-browsing \
  --disable-webif \
  --disable-dnssd \
  --without-perl \
  --without-python \
  --without-php \
  --without-java \
	--disable-raw-printing \
	--without-rcdir \
	--disable-acl \
	--with-extra-cflags="-I$ANDROID_INCLUDE -I$ANDROID_INCLUDE/$TARGET -Dlockf=fcntl_lockf"
	--with-extra-cxxflags=""
	--with-extra-ldflags="--sysroot=$SYSROOT"
	CC=$thecc \
	CXX=$thecxx \
	AR=$TOOLCHAIN/bin/llvm-ar \
	AS=$TOOLCHAIN/bin/llvm-as \
	LD=$TOOLCHAIN/bin/ld \
	OBJCOPY=$TOOLCHAIN/bin/llvm-objcopy \
	RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
	STRIP=$TOOLCHAIN/bin/llvm-strip \
	|| error_code=$?

if [[ "$error_code" -ne 0 ]]; then
  echo "\n\nCONFIGURE ERROR $error_code, config.log:"
  cat ${PWD}/config.log
  exit $error_code
fi

CFLAGS=-fno-rtti CXXFLAGS=-fno-rtti make -j$(nproc)
make install

cd ..
