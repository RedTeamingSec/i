#!/bin/bash

# Tentukan direktori prefix Xorg (ubah jika Anda menggunakan prefix selain /usr)
XORG_PREFIX="/usr"  # Ganti dengan /opt/Xorg atau prefix lain jika diperlukan

# Konfigurasi untuk semua paket Xorg
XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

# Membuat file konfigurasi untuk Xorg
cat > /etc/profile.d/xorg.sh << EOF
# Setel direktori Xorg Prefix
export XORG_PREFIX="$XORG_PREFIX"

# Setel konfigurasi untuk paket Xorg
export XORG_CONFIG="$XORG_CONFIG"

# Menambahkan direktori bin Xorg ke dalam PATH
export PATH=$XORG_PREFIX/bin:$PATH

# Menambahkan direktori pkgconfig Xorg ke dalam PKG_CONFIG_PATH
export PKG_CONFIG_PATH=$XORG_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=$XORG_PREFIX/share/pkgconfig:$PKG_CONFIG_PATH

# Menambahkan direktori library Xorg ke dalam LIBRARY_PATH
export LIBRARY_PATH=$XORG_PREFIX/lib:$LIBRARY_PATH

# Menambahkan direktori header Xorg ke dalam C_INCLUDE_PATH dan CPLUS_INCLUDE_PATH
export C_INCLUDE_PATH=$XORG_PREFIX/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$XORG_PREFIX/include:$CPLUS_INCLUDE_PATH

# Setel ACLocal untuk menemukan file aclocal yang diperlukan
export ACLOCAL="aclocal -I $XORG_PREFIX/share/aclocal"

# Ekspor semua variabel yang telah disetel
export PATH PKG_CONFIG_PATH ACLOCAL LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
EOF

# Berikan izin yang benar untuk file skrip
chmod 644 /etc/profile.d/xorg.sh

# Aktifkan skrip konfigurasi di sesi saat ini
source /etc/profile.d/xorg.sh

# Pastikan XORG_PREFIX dan XORG_CONFIG tersedia dalam sudo environment (Jika menggunakan sudo)
cat > /etc/sudoers.d/xorg << EOF
Defaults env_keep += XORG_PREFIX
Defaults env_keep += XORG_CONFIG
EOF

# Tambahkan direktori lib Xorg ke dalam ld.so.conf
echo "$XORG_PREFIX/lib" >> /etc/ld.so.conf
sudo ldconfig

# Perbarui man_db.conf untuk memastikan man pages Xorg ditemukan
sed -e "s@X11R6/man@X11R6/share/man@g" \
    -e "s@/usr/X11R6@$XORG_PREFIX@g"   \
    -i /etc/man_db.conf

# Buat symbolic link untuk X11 dan /usr/X11R6
ln -svf $XORG_PREFIX/share/X11 /usr/share/X11
ln -svf $XORG_PREFIX /usr/X11R6

# Skrip selesai, Xorg sudah siap digunakan
echo "Konfigurasi Xorg selesai. Pastikan untuk me-reboot atau menjalankan 'source /etc/profile.d/xorg.sh' untuk mengaktifkan konfigurasi."
