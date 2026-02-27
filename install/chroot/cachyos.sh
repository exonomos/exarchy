echo "-> Integrating CachyOS repositories..."
# CachyOS Repo-Integration herunterladen und ausführen
curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo

# Das Skript richtet pacman.conf und die Keyrings automatisch ein
./cachyos-repo.sh --noconfirm

cd ..
rm -rf cachyos-repo cachyos-repo.tar.xz

echo "-> Installing CachyOS Kernel..."
pacman -S --noconfirm linux-cachyos linux-cachyos-headers
