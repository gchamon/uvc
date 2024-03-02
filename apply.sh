#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# build and install the kernel mod persistently
sudo --user $(id --name --user 1000) bash -c 'make -C /lib/modules/$(uname -r)/build M=$PWD'
make -C /lib/modules/$(uname -r)/build M=$PWD modules_install

# reload kernel module to apply changes without having to reboot
sudo rmmod uvcvideo
sudo insmod $SCRIPT_DIR/uvcvideo.ko
