#!/bin/bash

# build a ubuntu base image

BUILDAH=$(which buildah)


ctr=$($BUILDAH from ubuntu:latest)


$BUILDAH run "$ctr" apt update
$BUILDAH config  --env DEBIAN_FRONTEND=noninteractive "$ctr"
$BUILDAH run "$ctr" apt install -y \
    curl dbus kmod iproute2 iputils-ping net-tools openssh-server \
    openssh-client sudo systemd systemd-sysv udev vim-tiny wget \
    libnss-resolve linux-image-virtual 
$BUILDAH run "$ctr" apt clean
$BUILDAH run "$ctr" rm -rf /var/lib/apt/lists/*

$BUILDAH run "$ctr" sh -c 'echo "root:root" | chpasswd'
$BUILDAH run "$ctr" sh -c 'echo "ubuntu-base" > /etc/hostname'

$BUILDAH run "$ctr" systemctl enable systemd-networkd.service
$BUILDAH run "$ctr" systemctl enable systemd-resolved.service
$BUILDAH run "$ctr" sh -c 'echo "[Match]\nName=en*\n[Network]\nDHCP=yes\n" > /etc/systemd/network/20-wired.network' 

$BUILDAH commit "$ctr" ubuntu-base-vm
$BUILDAH rm "$ctr"