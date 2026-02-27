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
