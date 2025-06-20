export NDK_VERSION=r27b

export BUILD_FREETYPE_VERSION="2.10.0"

export JVM_PLATFORM=linux
export API=21

# Runners usually ship with a recent NDK already
if [[ -z "$ANDROID_NDK_HOME" ]]
then
  export ANDROID_NDK_HOME=$PWD/android-ndk-$NDK_VERSION
fi

export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

export SYSROOT=$TOOLCHAIN/sysroot

export ANDROID_INCLUDE=$TOOLCHAIN/sysroot/usr/include

# If I'm right it should only need the dummy libs
export CPPFLAGS="-I$ANDROID_INCLUDE -I$ANDROID_INCLUDE/$TARGET"
export CPPFLAGS=""
export LDFLAGS=""

# Underlying compiler called by the wrappers
export thecc=$TOOLCHAIN/bin/${TARGET}${API}-clang
export thecxx=$TOOLCHAIN/bin/${TARGET}${API}-clang++

# Configure and build.
export AR=$TOOLCHAIN/bin/llvm-ar
export AS=$TOOLCHAIN/bin/llvm-as
export CC=$thecc
export CXX=$thecxx
export LD=$TOOLCHAIN/bin/ld
export OBJCOPY=$TOOLCHAIN/bin/llvm-objcopy
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

export JVM_VARIANTS=client
