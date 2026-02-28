#!/usr/bin/env bash

set -e

# Der Pfad innerhalb des chroots
export EXARCHY_INSTALL="/root/exarchy/install"

source "$EXARCHY_INSTALL/chroot-system/locale.sh"
source "$EXARCHY_INSTALL/chroot-system/hostname.sh"
source "$EXARCHY_INSTALL/chroot-system/cachyos-repo.sh"
source "$EXARCHY_INSTALL/chroot-system/cachyos-kernel.sh"
source "$EXARCHY_INSTALL/chroot-system/bootloader.sh"
