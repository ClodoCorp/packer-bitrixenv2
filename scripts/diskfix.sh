#!/bin/sh -ex

yum install -y parted

echo -n "o
n
p
1
2048

a
1
w
" | fdisk -cu /dev/sda || partprobe /dev/sda || true
resize2fs /dev/sda1
