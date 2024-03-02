# uvc video 
Linux kernel UVC for Quanta Computer, Inc. ACER HD User Facing (0408:4035)

`master` branch based on linux kernel 6.5, should support up to version 6.7

`kernel6.2` tag - based on linux kernel 6.1.7

**WARNING**: kernel 6.8 is known to modify the uvc driver. Don't apply this patch if on kernel 6.8.

# Prerequisites

First and foremost, you are about to apply a kernel patch:
1. Don't be reckless
2. Get familiar with what this repo is supposed to do. Read `apply.sh` and the `*.patch` file.
3. Optionally, if on archlinux, read what `archlinus-deploy.sh` does.
4. Make sure your kernel is supported.
5. Audit this repository. Download the linux sourcecode from `torvalds/linux`, checkout the tag related to your kernel version and run `diff --recursive ...` passing both repository folders.

## Dependencies

* rsync
* git
* gcc
* kernel-headers

# Usage

1. Clone repo
2. Run `sudo bash apply.sh`
3. Optionally, on archlinux, `sudo bash archlinux-deploy.sh`

