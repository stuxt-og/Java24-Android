#!/usr/bin/bash
export ANDROID_NDK_HOME=$PWD/android-ndk-r27b
	
export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

export SYSROOT=$TOOLCHAIN/sysroot
