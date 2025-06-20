export NDK_VERSION=r27b

export JVM_PLATFORM=linux
export API=21

export ANDROID_NDK_HOME=$(pwd)/android-ndk-r27b

export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

export SYSROOT=$TOOLCHAIN/sysroot

export ANDROID_INCLUDE=$SYSROOT/usr/include

# If I'm right it should only need the dummy libs
export CPPFLAGS="-I$ANDROID_INCLUDE -I$ANDROID_INCLUDE/$TARGET"
export CPPFLAGS=""
export LDFLAGS=""

# Underlying compiler called by the wrappers
export thecc=$TOOLCHAIN/bin/armv7a-linux-androideabi21-clang
export thecxx=$TOOLCHAIN/bin/armv7a-linux-androideabi21-clang++

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
