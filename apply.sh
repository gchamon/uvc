#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

cleanup () {
    if ! make -C /lib/modules/$(uname -r)/build M=$PWD clean; then
        echo Unable to cleanup build. Skipping...
    fi
    git reset --hard HEAD
}
trap cleanup EXIT
cleanup

git apply -v media-uvcvideo-Force-UVC-version-to-1.0a-for-0408-4035.diff

# build and install the kernel mod persistently
sudo --user $(id --name --user 1000) bash -c 'make -C /lib/modules/$(uname -r)/build M=$PWD'
make -C /lib/modules/$(uname -r)/build M=$PWD modules_install

# reload kernel module to apply changes without having to reboot
if rmmod uvcvideo; then
    insmod $SCRIPT_DIR/uvcvideo.ko
else
    echo Unable to remove uvcvideo module, probably in use. Skipping...
fi

