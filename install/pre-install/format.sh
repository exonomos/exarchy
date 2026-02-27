echo "-> Formatting EFI partition..."
mkfs.fat -F 3 "${DISK}1"

echo "-> Formatting LUKS container with BTRFS..."
mkfs.btrfs -f /dev/mapper/cryptroot
