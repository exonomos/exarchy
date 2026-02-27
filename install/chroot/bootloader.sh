echo "-> Installing Limine, Snapper, and Sync tools..."
pacman -S --noconfirm limine limine-snapper-sync snapper snap-pac

echo "-> Deploying Limine to EFI..."
mkdir -p /boot/EFI/BOOT
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/BOOTX64.EFI

CRYPT_UUID=$(blkid -s UUID -o value /dev/vda2)

echo "-> Configuring Limine..."
cat <<EOF >/boot/limine.conf
TIMEOUT=3

/CachyOS
    protocol: linux
    path: boot():/vmlinuz-linux-cachyos
    cmdline: root=/dev/mapper/cryptroot rootflags=subvol=@ rw quiet loglevel=3 rd.luks.name=${CRYPT_UUID}=cryptroot
    module_path: boot():/intel-ucode.img
    module_path: boot():/initramfs-linux-cachyos.img

/Vanilla Arch Fallback
    protocol: linux
    path: boot():/vmlinuz-linux
    cmdline: root=/dev/mapper/cryptroot rootflags=subvol=@ rw quiet loglevel=3 rd.luks.name=${CRYPT_UUID}=cryptroot
    module_path: boot():/intel-ucode.img
    module_path: boot():/initramfs-linux.img

//Snapshots
EOF

# Wichtig für den Sync-Dienst, damit er weiß, welchen Eintrag er kopieren soll
echo "TARGET_OS_NAME=CachyOS" >/etc/default/limine

echo "-> Adapting mkinitcpio hooks for LUKS and systemd..."
sed -i 's/^HOOKS=(.*)/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo "-> Configuring Snapper (Flat Layout Workaround)..."
# Snapper zickt, wenn /.snapshots schon gemountet ist. Wir müssen es kurz unmounten,
# die Config erstellen, das störende Subvolume löschen und unseres wieder einhängen.
umount /.snapshots
rm -rf /.snapshots
snapper -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a

echo "-> Enabling Snapper and Limine sync timers..."
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
