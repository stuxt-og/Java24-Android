#!/usr/bin/bash
# $1 - arch for apt

echo "http://ports.ubuntu.com/ubuntu-ports/" | sudo tee -a /etc/apt/apt-mirrors.txt

sudo dpkg --add-architecture $1

sudo apt-get update

sudo apt-get install --only-upgrade apt

mkdir debtemp

cd debtemp

sudo apt download libxrandr-dev:$1 libxtst-dev:$1 libcups2-dev:$1 libasound2-dev:$1 libfreetype6-dev:$1

cd ..

dpkg-deb -x debtemp/*.deb $SYSROOT
