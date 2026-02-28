#!/usr/bin/env bash

echo "-> Installing Limine, Snapper, and Sync tools..."
pacman -S --noconfirm limine limine-snapper-sync snapper snap-pac inotify-tools

echo "-> Deploying Limine to EFI..."
mkdir -p /boot/EFI/BOOT
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/BOOTX64.EFI

CRYPT_UUID=$(blkid -s UUID -o value /dev/vda2)

echo "-> Configuring Limine..."
cat <<EOF >/boot/limine.conf
TIMEOUT=3

/CachyOS
//CachyOS Default
    protocol: linux
    path: boot():/vmlinuz-linux-cachyos
    cmdline: root=/dev/mapper/cryptroot rootflags=subvol=@ rw quiet loglevel=3 rd.luks.name=${CRYPT_UUID}=cryptroot
    module_path: boot():/intel-ucode.img
    module_path: boot():/initramfs-linux-cachyos.img

/Vanilla Arch Fallback
//Vanilla Arch Fallback Default
    protocol: linux
    path: boot():/vmlinuz-linux
    cmdline: root=/dev/mapper/cryptroot rootflags=subvol=@ rw quiet loglevel=3 rd.luks.name=${CRYPT_UUID}=cryptroot
    module_path: boot():/intel-ucode.img
    module_path: boot():/initramfs-linux.img

//Snapshots
EOF

echo "-> Configuring Limine sync variables..."
echo "TARGET_OS_NAME=CachyOS" >/etc/default/limine
# Teilt dem Sync-Tool mit, dass wir ein BTRFS Flat-Layout (@snapshots) nutzen
echo "ROOT_SNAPSHOTS_PATH=/@snapshots" >>/etc/default/limine

echo "-> Adapting mkinitcpio hooks for LUKS and systemd..."
sed -i 's/^HOOKS=(.*)/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo "-> Configuring Snapper (Manual Flat Layout Workaround for chroot)..."
# 1. Wir legen die Config-Datei manuell an, anstatt 'snapper -c root create-config' zu nutzen,
#    da dbus im chroot nicht verlässlich läuft.
mkdir -p /etc/snapper/configs
cp /usr/share/snapper/config-templates/default /etc/snapper/configs/root

# 2. Wir passen die root-Config an, damit sie auf BTRFS zugreift und Timeline-Snapshots aktiviert sind
sed -i 's/^SUBVOLUME=.*/SUBVOLUME="\/"/' /etc/snapper/configs/root
sed -i 's/^ALLOW_USERS=.*/ALLOW_USERS="exonomos"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_CREATE=.*/TIMELINE_CREATE="yes"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_LIMIT_HOURLY=.*/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_LIMIT_DAILY=.*/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_LIMIT_WEEKLY=.*/TIMELINE_LIMIT_WEEKLY="0"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_LIMIT_MONTHLY=.*/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_LIMIT_YEARLY=.*/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root

# 3. Wir machen Snapper die Config bekannt
sed -i 's/^SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root"/' /etc/conf.d/snapper

echo "-> Enabling Snapper and Limine sync timers..."
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
