#!/bin/bash

# Meminta pengguna memasukkan nama file
echo "Masukkan nama file:"
read nama_project

echo "Pilih Project: 1.LOS A13, 2.ArrowOS, 3. LOS A14"
read nomer_project

# Menetapkan nama file sebagai variabel
nama_project="$rom_nama"


# Membuat Project sesuai variabel

mkdir "$rom_nama"
cd "$rom_nama"
crave 
