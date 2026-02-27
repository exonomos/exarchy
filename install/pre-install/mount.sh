echo "-> Creating BTRFS subvolumes..."
mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@snapshots

umount /mnt

echo "-> Mounting BTRFS subvolumes..."
# Standard BTRFS Optimierungen (SSD friendly)
BTRFS_OPTS="noatime,compress=zstd,space_cache=v2"

# Mount Root (@) first
mount -o "$BTRFS_OPTS",subvol=@ /dev/mapper/cryptroot /mnt

# Create mount points
mkdir -p /mnt/{home,root,srv,var/cache,var/log,var/tmp,boot,.snapshots}

# Mount remaining subvolumes
mount -o "$BTRFS_OPTS",subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o "$BTRFS_OPTS",subvol=@root /dev/mapper/cryptroot /mnt/root
mount -o "$BTRFS_OPTS",subvol=@srv /dev/mapper/cryptroot /mnt/srv
mount -o "$BTRFS_OPTS",subvol=@cache /dev/mapper/cryptroot /mnt/var/cache
mount -o "$BTRFS_OPTS",subvol=@log /dev/mapper/cryptroot /mnt/var/log
mount -o "$BTRFS_OPTS",subvol=@tmp /dev/mapper/cryptroot /mnt/var/tmp
mount -o "$BTRFS_OPTS",subvol=@snapshots /dev/mapper/cryptroot mnt/.snapshots

echo "-> Mounting EFI partition..."
mount "${DISK}1" /mnt/boot

echo "-> Mounts completed successfully."
