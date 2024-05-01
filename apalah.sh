# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init --depth=1 -u https://github.com/crdroidandroid/android -b 14.0 --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel packages/apps/Settings hardware/xiaomi

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi


# Let's sync!
/opt/crave/resync.sh
rm -rf packages/apps/Settings

git clone https://github.com/newestzdn/android_packages_apps_Settings packages/apps/Settings

git clone -b cr https://github.com/zaidanprjkt/device_xiaomi_chime_2 device/xiaomi/chime

# Do lunch
. build/envsetup.sh
lunch lineage_lime-ap1a-userdebug

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export SELINUX_IGNORE_NEVERALLOWS=true

# Let's start build!
m bacon -j$(nproc --all)

lunch lineage_citrus-ap1a-userdebug
m bacon -j$(nproc --all)
