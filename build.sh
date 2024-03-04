# Simple Script for building ROM, Especially Crave.
# For Personal only, but you can fork and use it.
# Copyright (C) 2023 newestzdn

# Define variable 
device_codename=juice
rom_name=lineage
build_type=userdebug
branch_tree=los-q
branch_rom=lineage-17.1
rom_manifest="https://github.com/LineageOS-Revived/android.git"
build_command="make bacon"

# Do repo init for rom that we want to build.
repo init -u "${rom_manifest}" -b "${branch_rom}"  --git-lfs --depth=1 --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device/xiaomi
rm -rf vendor/xiaomi
rm -rf kernel

# Clone our local manifest.
git clone https://github.com/zaidanprjkt/local_manifest.git --depth 1 -b $branch_tree .repo/local_manifests

# Do remove here before repo sync.
#rm -rf prebuilts/clang/host/linux-x86

# Let's sync!
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune
    
# Do lunch
source build/envsetup.sh 
lunch "${rom_name}"_"${device_codename}"-userdebug

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=crave       
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority

# Define timezone
export TZ=Asia/Jakarta

# Let's start build!
$build_command -j$(nproc --all)
