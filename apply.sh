#!/bin/bash
set -euxo pipefail

sudo --user $(id --name --user 1000) bash -c 'make -C /lib/modules/$(uname -r)/build M=$PWD'
make -C /lib/modules/$(uname -r)/build M=$PWD modules_install
