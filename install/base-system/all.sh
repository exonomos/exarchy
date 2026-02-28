#!/usr/bin/env bash

echo ">>> Starting installationphase base-system..."

source "$EXARCHY_INSTALL/base-system/pacstrap.sh"
source "$EXARCHY_INSTALL/base-system/fstab.sh"

echo ">>>Installationphase base-system complete."
