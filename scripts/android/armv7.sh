#!/usr/bin/bash
. scripts/android/setup_env.sh

export API=21
export TARGET=armv7a-linux-androideabi

export CFLAGS="-I$ANDROID_INCLUDE -I$ANDROID_INCLUDE/$TARGET -mllvm -polly -DANDROID -Wno-error=implicit-function-declaration -Wno-error=int-conversion -DLE_STANDALONE -O3 -D__thumb__"
export CPPFLAGS=$CFLAGS
export LDFLAGS="--sysroot=$SYSROOT -L$SYSROOT/usr/lib -L$PWD/dummy_libs -Wl,--undefined-veirsion"

# Underlying compiler called by the wrappers
export thecc=$TOOLCHAIN/bin/${TARGET}${API}-clang

export thecxx=$TOOLCHAIN/bin/${TARGET}${API}-clang++

# Configure and build.
export AR=$TOOLCHAIN/bin/llvm-ar
export AS=$TOOLCHAIN/bin/llvm-as
export CC=$PWD/android-wrapped-clang
export CXX=$PWD/android-wrapped-clang++
export LD=$TOOLCHAIN/bin/ld
export OBJCOPY=$TOOLCHAIN/bin/llvm-objcopy
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

chmod +x android-wrapped-clang
chmod +x android-wrapped-clang++
ln -s -f /usr/include/X11 $ANDROID_INCLUDE/
ln -s -f /usr/include/fontconfig $ANDROID_INCLUDE/

export FREETYPE_DIR=$PWD/freetype-$BUILD_FREETYPE_VERSION/build_android-arm
export CUPS_DIR=cups-2.2.4

# Create dummy libraries so we won't have to remove them in OpenJDK makefiles
mkdir -p dummy_libs
ar cru dummy_libs/libpthread.a
ar cru dummy_libs/librt.a
ar cru dummy_libs/libthread_db.a

# fix building libjawt
sudo ln -s -f $CUPS_DIR/cups $ANDROID_INCLUDE/

bash configure \
	--with-conf-name=$TARGET \
	--openjdk-target=$TARGET \
	--with-boot-jdk=$1\
	--with-extra-cflags="$CFLAGS" \
	--with-extra-cxxflags="$CXXFLAGS" \
	--with-extra-ldflags="$LDFLAGS" \
	--with-zlib=system \
	--with-jmod-compress=zip-1 \
	--with-version-opt=$2 \
	--with-gtest=$3 \
	--enable-headless-only \
	--disable-warnings-as-errors \
	--x-includes=$ANDROID_INCLUDE/X11 \
	--enable-option-checking=fatal \
	--with-jvm-variants=client \
	--with-jvm-features=-dtrace,-zero,-vm-structs,-epsilongc \
	--with-devkit=$TOOLCHAIN \
	--with-native-debug-symbols=external \
	--disable-precompiled-headers \
	--with-fontconfig-include=$ANDROID_INCLUDE \
	--x-includes=$ANDROID_INCLUDE/X11 \
	--x-libraries=/usr/lib \
	--with-cups-include=$CUPS_DIR \
	--with-toolchain-type=gcc \
	OBJCOPY=${OBJCOPY} \
	RANLIB=${RANLIB} \
	AR=${AR} \
	STRIP=${STRIP} \
	--with-cups-include=$CUPS_DIR || ( \
	echo "Dumping config.log:" && \
	cat config.log && \
	exit 1)
