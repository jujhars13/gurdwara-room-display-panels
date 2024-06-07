# cloud-init on a Raspberry Pi

![main](https://github.com/jsiebens/rpi-cloud-init/actions/workflows/build.yaml/badge.svg?branch=main)

This repository contains Packer templates and scripts to build a Raspbian / Raspberry Pi OS image with [cloud-init](https://cloud-init.io/) pre-installed.

> cloud-init: Cloud images are operating system templates and every instance starts out as an identical clone of every other instance. It is the user data that gives every cloud instance its personality and cloud-init is the tool that applies user data to your instances automatically.

This setup includes the following image:

- __rpi-cloud-init.img__: a image with cloud-init pre-installed. 

## How to use this image

```bash
packer init packer/
packer build -parallel-builds=1 packer/

## burn image to sd card, assume /dev/sdc
< images/rpi-raspios-arm64.img | sudo dd bs=100M of=/dev/sdc status=progress
```
