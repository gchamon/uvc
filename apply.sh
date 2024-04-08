#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

cleanup () {
    for module in $(/bin/ls -1 /lib/modules); do
        if [ -d /lib/modules/"$module"/build ]; then
            if ! make -C /lib/modules/$module/build M=$PWD clean; then
                echo Unable to cleanup build. Skipping...
            fi
        fi
    done
    git reset --hard HEAD
}
trap cleanup EXIT
cleanup

git apply -v media-uvcvideo-Force-UVC-version-to-1.0a-for-0408-4035.diff

# build and install the kernel mod persistently
for module in $(/bin/ls -1 /lib/modules); do
    if [ -d /lib/modules/"$module"/build ]; then
        sudo --user $(id --name --user 1000) bash -c "make -C /lib/modules/$module/build M=$PWD"
        make -C /lib/modules/$module/build M=$PWD modules_install
        if [[ "$module" == $(uname -r) ]]; then
            mv uvcvideo.ko cur-uvcvideo.ko
        fi
    fi
done

# reload kernel module to apply changes without having to reboot
if [ -f cur-uvcvideo.ko ]; then
    if rmmod uvcvideo; then
        insmod cur-uvcvideo.ko
    else
        echo Unable to remove uvcvideo module, probably in use. Skipping...
    fi
fi

