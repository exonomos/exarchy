#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Dynamically resolve the absolute path to the repository root
export EXARCHY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export EXARCHY_INSTALL="$EXARCHY_PATH/install"

# ==========================================
# PHASE 0: INITIALIZE HELPERS
# ==========================================

source "$EXARCHY_INSTALL/helpers/all.sh"

info "Starting Exarchy installation on $DISK..."

# ==========================================
# PHASE 1: LIVE ENVIRONMENT (Outside chroot)
# ==========================================

source "$EXARCHY_INSTALL/preflight/all.sh"
source "$EXARCHY_INSTALL/disk-setup/all.sh"
source "$EXARCHY_INSTALL/base-system/all.sh"

# ==========================================
# PHASE 2: CHROOT ENVIRONMENT (Inside /mnt)
# ==========================================

info "Transitioning to chroot environment..."

# Copy the entire repository to the new system
cp -R "$EXARCHY_PATH" /mnt/root/exarchy
cp "$ENV_FILE" /mnt/root/exarchy.env

# Execute all remaining phases within the chroot using a single statement
arch-chroot /mnt /bin/bash -c "
    set -e

    source /root/exarchy.env

    source /root/exarchy/install/chroot-system/all.sh && \
    source /root/exarchy/install/chroot-general/all.sh && \
    source /root/exarchy/install/hardware-daemons/all.sh && \
    source /root/exarchy/install/desktop-hyprland/all.sh && \
    source /root/exarchy/install/user-space/all.sh && \
    source /root/exarchy/install/dotfiles/all.sh

    shred -u /root/exarchy.env
"

success "Installation complete. You can now reboot."
