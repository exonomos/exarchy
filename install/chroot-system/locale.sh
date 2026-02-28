#!/usr/bin/env bash

echo "-> Setting timezone..."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

echo "-> Setting locale..."
# Entkommentiere US-Englisch (OS-Sprache) und Deutsch (Fallback/Formate)
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >/etc/locale.conf

echo "-> Setting console keymap..."
echo "KEYMAP=de-latin1" >/etc/vconsole.conf
