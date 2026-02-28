#!/usr/bin/env bash

echo "-> Integrating CachyOS repositories..."
# CachyOS Repo-Integration herunterladen und ausführen
curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo

# Das Skript richtet pacman.conf und die Keyrings automatisch ein
yes | ./cachyos-repo.sh

cd ..
rm -rf cachyos-repo cachyos-repo.tar.xz
