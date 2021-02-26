#!/bin/bash

# build a archlinux base image

BUILDAH=$(which buildah)


ctr=$($BUILDAH from archlinux:latest)


$BUILDAH run "$ctr" pacman --noconfirm -Syy
$BUILDAH run "$ctr" pacman --noconfirm -S \
    curl dbus kmod iproute2 iputils net-tools openssh \
    sudo systemd systemd-sysvcompat vim wget \
    linux
$BUILDAH run "$ctr" pacman --noconfirm -Scc

$BUILDAH run "$ctr" sh -c 'echo "root:root" | chpasswd'
$BUILDAH run "$ctr" sh -c 'echo "archlinux-base" > /etc/hostname'

$BUILDAH run "$ctr" systemctl enable sshd
$BUILDAH run "$ctr" systemctl enable systemd-networkd.service
$BUILDAH run "$ctr" systemctl enable systemd-resolved.service
$BUILDAH run "$ctr" systemctl enable systemd-timesyncd
$BUILDAH run "$ctr" sh -c 'echo -e "[Match]\nName=en*\n[Network]\nDHCP=yes\n" > /etc/systemd/network/20-wired.network' 

$BUILDAH run "$ctr" /usr/bin/systemd-firstboot --locale=en_US.UTF-8 --timezone=UTC --hostname=archlinux-base-vm --keymap=us

$BUILDAH commit "$ctr" archlinux-base-vm
$BUILDAH rm "$ctr"