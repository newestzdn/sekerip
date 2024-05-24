# Simple Script for building ROM, Especially Crave.

# Clean all manifest
rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init --depth=1 -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device/xiaomi vendor/xiaomi kernel/xiaomi hardware/xiaomi platfrom
#packages/apps/Settings frameworks/base 

# Let's sync!
/opt/crave/resync.sh

git clone --depth=1 -b 14 https://github.com/zaidanprjkt/device_xiaomi_chime_2 device/xiaomi/chime

#git clone --depth=1 https://github.com/crdroidandroid/android_hardware_xiaomi hardware/xiaomi

# Do lunch
. build/envsetup.sh

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export SELINUX_IGNORE_NEVERALLOWS=true
export BUILD_BROKEN_INCORRECT_PARTITION_IMAGES=true
#export TARGET_DEFAULT_PIXEL_LAUNCHER=true 

riseup lime userdebug
rise b

riseup citrus userdebug
rise b



