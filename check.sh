#!/bin/bash

# Daftar pustaka Xorg yang akan diperiksa
libs=(
    "libX11.so"
    "libXext.so"
    "libXcursor.so"
    "libXdamage.so"
    "libXfixes.so"
    "libXfont2.so"
    "libXft.so"
    "libXi.so"
    "libXinerama.so"
    "libXrandr.so"
    "libXrender.so"
    "libXt.so"
    "libXtst.so"
    "libXv.so"
    "libXvMC.so"
    "libXxf86dga.so"
    "libXxf86vm.so"
)

# Direktori tempat pustaka Xorg diinstal (ubah jika perlu)
XORG_LIB_DIR="/usr/lib"

# Fungsi untuk memeriksa keberadaan pustaka
check_lib() {
    local lib=$1
    if [[ -f "$XORG_LIB_DIR/$lib" ]]; then
        echo "[OK] $lib ditemukan"
    else
        echo "[ERROR] $lib TIDAK ditemukan"
    fi
}

# Memeriksa setiap pustaka dalam daftar
echo "Memeriksa Xorg Libraries..."
for lib in "${libs[@]}"; do
    check_lib $lib
done

# Selesai
echo "Pemeriksaan selesai."
