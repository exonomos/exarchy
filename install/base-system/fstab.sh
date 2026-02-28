#!/usr/bin/env bash

echo "-> Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab

# Kurzer Check im Log, ob die fstab befüllt wurde
cat /mnt/etc/fstab
