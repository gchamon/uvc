#/bin/bash
set -euxo pipefail

TARGET_DIR=/usr/local/src/uvc-patch
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rm --recursive --force $TARGET_DIR
mkdir --parents $TARGET_DIR
rsync --verbose --archive $SCRIPT_DIR/ $TARGET_DIR

cat > /etc/pacman.d/hooks/99-uvc-patch.hook <<EOF
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux*

[Action]
Description = Reinstalling uvc patch...
When = PostTransaction
Exec = /bin/bash $TARGET_DIR/apply.sh
EOF

