#!/usr/bin/env bash

echo "-> Formatting EFI partition..."
mkfs.fat -F 32 "${DISK}1"

echo "-> Formatting LUKS container with BTRFS..."
mkfs.btrfs -f /dev/mapper/cryptroot
