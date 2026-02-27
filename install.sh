#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Dynamically resolve the absolute path to the repository root
export EXARCHY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export EXARCHY_INSTALL="$EXARCHY_PATH/install"

# Set variable for disk
export DISK="/dev/vda"

# Execute the pre-install sequence
echo ">>> Starting pre-install process..."
source "$EXARCHY_INSTALL/pre-install/all.sh"
echo ">>> Pre-install complete."

# Execute the base system installation
echo ">>> Starting base system installation..."
source "$EXARCHY_INSTALL/base/all.sh"
echo ">>> Base system installation complete."

# Change root into the new system
echo ">>> Starting chroot configuration..."
# Kopiere das gesamte Repo in das neue System
cp -R "$EXARCHY_PATH" /mnt/root/exarchy
# Führe das chroot-Verteilerskript innerhalb des neuen Systems aus
arch-chroot /mnt /bin/bash "/root/exarchy/install/chroot/all.sh"
echo ">>> Chroot configuration complete."
