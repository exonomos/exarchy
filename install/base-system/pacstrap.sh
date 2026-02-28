#!/usr/bin/env bash

echo "-> Installing base system via pacstrap..."
pacstrap -K /mnt base base-devel linux-firmware intel-ucode btrfs-progs networkmanager nvim git
