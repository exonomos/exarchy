#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Dynamically resolve the absolute path to the repository root
export EXARCHY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export EXARCHY_INSTALL="$EXARCHY_PATH/install"

echo ">>> Starting Exarchy bootstrap process..."

# Execute the pre-install sequence
source "$EXARCHY_INSTALL/pre-install/all.sh"

echo ">>> Exarchy pre-install complete."
