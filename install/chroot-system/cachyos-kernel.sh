#!/usr/bin/env bash

echo "-> Installing CachyOS Kernel..."
pacman -S --noconfirm linux-cachyos linux-cachyos-headers linux-cachyos-lts linux-cachyos-lts-headers
