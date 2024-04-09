#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

cleanup_module () {
    module_name=$1
    if [ -d /lib/modules/"$module_name"/build ]; then
        if ! make -C /lib/modules/$module_name/build M=$PWD clean; then
            echo Unable to cleanup build. Skipping...
        fi
    fi
}
cleanup_all_modules () {
    for module in $(/bin/ls -1 /lib/modules); do
        cleanup_module $module
    done
}
cleanup_git () {
    git reset --hard HEAD
}
cleanup_all () {
    cleanup_all_modules
    cleanup_git
}
trap cleanup_all EXIT
cleanup_all

apply_mod_to_live_kernel() {
    if ! grep -q uvcvideo /proc/modules; then
        insmod uvcvideo.ko
    elif rmmod uvcvideo; then
        insmod uvcvideo.ko
    else
        echo Unable to load uvcvideo module. You might need to reboot...
    fi
}
build_and_install_mod() {
    sudo --user $(id --name --user 1000) bash -c "make -C /lib/modules/$module/build M=$PWD"
    make -C /lib/modules/$module/build M=$PWD modules_install
}

git apply -v media-uvcvideo-Force-UVC-version-to-1.0a-for-0408-4035.diff

# build and install the kernel mod persistently
for module in $(/bin/ls -1 /lib/modules); do
    if [ -d /lib/modules/"$module"/build ]; then
        build_and_install_mod
        if [[ "$module" == $(uname -r) ]]; then
            apply_mod_to_live_kernel
        fi
        cleanup_module $module
    fi
done

