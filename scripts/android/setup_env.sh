export NDK_VERSION=r27b

export JVM_PLATFORM=linux
export API=21

export ANDROID_NDK_HOME=$PWD/android-ndk-r27b

export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

export SYSROOT=$TOOLCHAIN/sysroot

export ANDROID_INCLUDE=$SYSROOT/usr/include

export thecc=$TOOLCHAIN/bin/armv7a-linux-androideabi21-clang
export thecxx=$TOOLCHAIN/bin/armv7a-linux-androideabi21-clang++

export JVM_VARIANTS=client
