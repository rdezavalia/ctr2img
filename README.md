# c2i

## Intro

**c2i** is a tool that let's  you build your linux vm's images using any [OCI](https://opencontainers.org/) compatible build tool.

All you need is a container with a valid linux kernel and init process (ex systemd)

## Usage

Usage is very simple:

```
# c2i -h
Usage: c2i [-h] [-d] [-k KEYFILE] CONTAINER IMAGEFILE
Convert a ContainerFile to a ImageFile
Options:
	-h		print this help
	-k KEYFILE	add ssh key to the root account
	-s SIZE	 disk size (default 2G)
	-d		turn on debug (use it multiple times to increse debug info)
	-q		generate a qcow2 image
Example:
	Create a 10G ubuntu image with your ssh key on it
	# c2i -s 10G -k ~/.ssh/id_rsa.pub localhost/ubuntu-base-vm /opt/images/ubuntu-base.img
	Create an ubuntu image with qcow2 format
	# c2i -q localhost/ubuntu-base-vm /opt/images/ubuntu-base.qcow2
```

## Examples

**c2i** let's you add you ssh key inside your vm image

```
# c2i -k ~/.ssh/id_rsa.pub localhost/ubuntu-container ~/ubuntu.img
```

You can also choose between raw (default) or qcow2 output:

```
# c2i -q localhost/ubuntu-container ~/ubuntu.qcow2
```
By default, the output images is 2 GB, but you can change it:

```
# c2i -s 20G localhost/ubuntu-container ~/ubuntu.img
```

## Dependencies

In order to run **c2i** you will need:

* [buildah](https://buildah.io/) - to manipulate the container an build the vm image
* [sgdisk](https://man.archlinux.org/man/extra/gptfdisk/sgdisk.8.en) - to partition the image file
* [syslinux](https://man.archlinux.org/man/syslinux.1) - this is the bootloader that **c2i** will install in your image.
* [qemu-img](https://man.archlinux.org/man/qemu-img.1) - to generate qcow2 images

## Building an OCI container compatible with c2i

Any container with a linux OS and a kernel and a init system will do. You can check the containers directory on this repo for some examples.

## Related

While developing this tool I found some similar projects that may be useful to you:

* [docker-to-linux](https://github.com/iximiuz/docker-to-linux)
* [darch](https://github.com/godarch/darch)