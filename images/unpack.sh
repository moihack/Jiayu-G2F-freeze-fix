#!/bin/bash
#
# Script for extracting rootfs from
# Jiayu G2F WCDMA mobile phone's boot
# partition image. Created for Debian.
#

f=$1

if [ -z "$f" ]; then
	echo "File required"
	exit 1
fi

if [ ! -x /usr/bin/abootimg ]; then
	echo "No abootimg tool. Try 'apt-get install abootimg' first."
	exit 1
fi

abootimg -x "$f"

dd if=initrd.img of=initrd.cpio.gz skip=1 bs=512

mkdir rootfs

cd rootfs

gunzip < "../initrd.cpio.gz" | cpio -vid

cd ..

