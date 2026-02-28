#!/usr/bin/env bash

echo "-> Installing Fish..."
pacman -S --noconfirm fish

USERNAME="exonomos"

echo "-> User Setup: $USERNAME"

# Passwort sicher und unsichtbar über das Terminal abfragen
while true; do
  read -s -p "Enter password for $USERNAME (and root): " PASSWORD
  echo
  read -s -p "Confirm password: " PASSWORD_CONFIRM
  echo

  if [ "$PASSWORD" = "$PASSWORD_CONFIRM" ] && [ -n "$PASSWORD" ]; then
    break
  else
    echo "Error: Passwords do not match or are empty. Please try again."
  fi
done

echo "-> Setting root password..."
echo "root:$PASSWORD" | chpasswd

echo "-> Creating user $USERNAME..."
useradd -m -G wheel -s /usr/bin/fish "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

echo "-> Configuring sudo privileges..."
# Erlaubt allen Mitgliedern der Gruppe 'wheel' die passwortgeschützte Nutzung von sudo
echo "%wheel ALL=(ALL:ALL) ALL" >/etc/sudoers.d/wheel

# Variable zur Sicherheit direkt wieder leeren
unset PASSWORD
unset PASSWORD_CONFIRM
