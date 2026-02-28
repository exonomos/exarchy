echo "-> Installing base system via pacstrap..."
pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode btrfs-progs networkmanager nvim git ssh
