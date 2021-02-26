#!/bin/bash

# build a debian base image

BUILDAH=$(which buildah)


ctr=$($BUILDAH from debian:latest)


$BUILDAH run "$ctr" apt update
$BUILDAH run "$ctr" apt install -y \
    curl dbus kmod iproute2 iputils-ping net-tools openssh-server \
    openssh-client sudo systemd systemd-sysv udev vim-tiny wget \
    linux-image-amd64
$BUILDAH run "$ctr" apt clean
$BUILDAH run "$ctr" rm -rf /var/lib/apt/lists/*

$BUILDAH run "$ctr" sh -c 'echo "root:root" | chpasswd'
$BUILDAH run "$ctr" sh -c 'echo "debian-base" > /etc/hostname'

$BUILDAH run "$ctr" systemctl enable systemd-networkd.service
$BUILDAH run "$ctr" systemctl enable systemd-resolved.service
$BUILDAH run "$ctr" sh -c 'echo -e "[Match]\nName=en*\n[Network]\nDHCP=yes\n" > /etc/systemd/network/20-wired.network' 

$BUILDAH commit "$ctr" debian-base-vm
$BUILDAH rm "$ctr"
