#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

sudo --user $(id --name --user 1000) bash -c 'make -C /lib/modules/$(uname -r)/build M=$PWD'
make -C /lib/modules/$(uname -r)/build M=$PWD modules_install
