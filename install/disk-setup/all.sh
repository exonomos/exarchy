#!/usr/bin/env bash

echo ">>> Starting installationphase disk-setup..."

source "$EXARCHY_INSTALL/disk-setup/partition.sh"
source "$EXARCHY_INSTALL/disk-setup/encrypt.sh"
source "$EXARCHY_INSTALL/disk-setup/format.sh"
source "$EXARCHY_INSTALL/disk-setup/mount.sh"

echo ">>>Installationphase disk-setup complete."
