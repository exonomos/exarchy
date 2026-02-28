#!/usr/bin/env bash

info "=== Exarchy Variable Setup ==="

echo ""
lsblk -d -p -n -l -o NAME,SIZE,MODEL | grep -v "loop"
echo ""

read -p "Target Disk (e.g., /dev/vda or /dev/nvme0n1): " TARGET_DISK
read -p "Hostname (e.g., exarchy): " TARGET_HOSTNAME
read -p "Username: " TARGET_USER

while true; do
  read -s -p "Password (for LUKS, Root, and User): " TARGET_PASSWORD
  echo ""
  read -s -p "Confirm Password: " TARGET_PASSWORD_CONFIRM
  echo ""
  [ "$TARGET_PASSWORD" = "$TARGET_PASSWORD_CONFIRM" ] && break
  warn "Passwords do not match. Please try again."
done

info "Saving configuration temporarily to RAM..."

export ENV_FILE="/tmp/exarchy.env"

cat <<EOF >"$ENV_FILE"
export DISK="$TARGET_DISK"
export HOSTNAME="$TARGET_HOSTNAME"
export USERNAME="$TARGET_USER"
export PASSWORD="$TARGET_PASSWORD"
EOF

chmod 600 "$ENV_FILE"
source "$ENV_FILE"

success "Variables successfully loaded."
