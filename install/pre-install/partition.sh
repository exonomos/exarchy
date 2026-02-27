echo "-> Wiping disk $DISK..."
sgdisk -Z "$DISK"

echo "-> Creating partitions..."
# Partition 1: 1GB EFI (ef00)
sgdisk -n 1:0:+1G -t 1:ef00 "$DISK"

# Partition 2: Remaining space for LUKS/Root (8300)
sgdisk -n 2:0:0 -t 2:8300 "$DISK"
