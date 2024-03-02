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
5. Audit this repository. Download the linux sourcecode from `torvalds/linux`, checkout the tag
related to your kernel version and run `diff --recursive ...` passing both this repo folder and
`drivers/media/usb/uvc` inside `linux` repository folder.

**NOTE**: You are not supposed to see any changes in the files pertaining to both this and the
linux repo. If any other changes are spotted either this repository or your local files might
have been compromised and you shouldn't apply the patch. Consider opening an issue.

This is what you are supposed to see when auditing this repository:
![image](https://github.com/gchamon/uvc/assets/9471861/1f548782-efdb-4c81-a68d-498678c4f85d)

## Dependencies

* rsync
* git
* gcc
* kernel-headers

# Usage

1. Clone repo
2. Run `sudo bash apply.sh`
3. Optionally, on archlinux, `sudo bash archlinux-deploy.sh`

