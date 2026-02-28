#!/usr/bin/env bash

echo "-> Refreshing keyrings and clearing broken cache..."
pacman -Sy --noconfirm archlinux-keyring cachyos-keyring
rm -rf /var/cache/pacman/pkg/*

echo "-> Installing CachyOS Kernel..."
pacman -S --noconfirm linux-cachyos linux-cachyos-headers linux-cachyos-lts linux-cachyos-lts-headers
