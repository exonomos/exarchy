echo "-> Setting up LUKS encryption on ${DISK}2..."
cryptsetup luksFormat "${DISK}2"

echo "-> Opening LUKS container as 'cryptroot'..."
cryptsetup open "${DISK}2" cryptroot
