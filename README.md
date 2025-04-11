**Deprecation notice:** It seems with kernel 6.12 or maybe earlier (build just stopped working
after 6.12) the driver is supported natively in the kernel, making this repo obsolete.

# uvc video 
Linux kernel UVC for Quanta Computer, Inc. ACER HD User Facing (0408:4035)

`master` branch based on linux kernel 6.5, should support up to version 6.7

`kernel6.2` tag - based on linux kernel 6.1.7

**WARNING**: kernel 6.8 is known to modify the uvc driver. Don't apply this patch if on kernel 6.8.

# Introduction

There is a known issue with the aforementioned device reporting UVC version 1.5 but implementing
UVC 1.0a. A working patch is described in <https://patchwork.kernel.org/project/linux-media/patch/20230115205210.20077-1-laurent.pinchart@ideasonboard.com/>.

On <https://bbs.archlinux.org/viewtopic.php?id=284160> there are instructions on how to download
the kernel source code and apply the patch. However after kernel reinstallations or upgrades the
patch is reversed. Re-downloading and reapplying the patch each time is time consuming and error-
prone, since the upstream repository is rather big (over 2GB).

The repo from which this repository is forked presents a nice alternative that is to separate and
modify only the necessary files for the UVC patch. However, applying custom kernel module
patches is a security hole and should not be done without proper code audit.

This repository aims to be a nice balance between the two approaches. The code in this repo is the
same as in the upstream linux repository. There are only added files for describing the patch and
for convenience scripts.

Furthermore, to illustrate how one might persist these changes across kernel upgrades, there is a
convenience script for archlinux installations that rely on pacman hooks to rebuild and reapply the
patch.

# Prerequisites

First and foremost, you are about to apply a kernel patch:
1. Don't be reckless
2. Get familiar with what this repo is supposed to do. Read `apply.sh` and the `*.patch` file.
3. Optionally, if on archlinux, read what `archlinux-deploy.sh` does.
4. Make sure your kernel is supported.
5. Audit this repository, using the instructions below.

## Dependencies

* rsync
* git
* gcc
* kernel-headers
* (optional) kernel-modules-hook (for archlinux pacman hook)

The last dependency is necessary to keep the current kernel modules headers and prevent the pacman
hook from breaking upon kernel upgrades.

# Auditing this repository

Download the linux sourcecode from `torvalds/linux`, checkout the tag
related to your kernel version and run `diff --recursive ...` passing both this repo folder and
`drivers/media/usb/uvc` inside `linux` repository folder.

**NOTE**: You are not supposed to see any changes in the files pertaining to both this and the
linux repo. If any other changes are spotted either this repository or your local files might
have been compromised and you shouldn't apply the patch. Consider opening an issue.

This is what you are supposed to see when auditing this repository:

```shell
$ diff --recursive ~/audit/uvc ~/audit/linux/drivers/media/usb/uvc
Only in /home/USER/audit/uvc: apply.sh
Only in /home/USER/audit/uvc: archlinux-deploy.sh
Only in /home/USER/audit/uvc: .git
Only in /home/USER/audit/uvc: .gitignore
Only in /home/USER/audit/uvc: media-uvcvideo-Force-UVC-version-to-1.0a-for-0408-4035.diff
Only in /home/USER/audit/uvc: README.md
```

# Usage

1. Clone repo
2. Run `sudo bash apply.sh`
3. Optionally, on archlinux, `sudo bash archlinux-deploy.sh`

