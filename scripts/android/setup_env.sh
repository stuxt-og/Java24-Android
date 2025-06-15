#!/usr/bin/sh
export ANDROID_NDK_HOME=$PWD/android-ndk
	
export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

export SYSROOT=$TOOLCHAIN/sysroot
