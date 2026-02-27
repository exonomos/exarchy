#!/usr/bin/env bash

set -e

# Der Pfad innerhalb des chroots
export EXARCHY_INSTALL="/root/exarchy/install"

source "$EXARCHY_INSTALL/chroot/system.sh"
source "$EXARCHY_INSTALL/chroot/cachyos.sh"
source "$EXARCHY_INSTALL/chroot/bootloader.sh"
