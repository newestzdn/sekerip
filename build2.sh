# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init --depth=1 -u https://github.com/CherishOS/android_manifest.git -b uqpr2 --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel hardware prebuilts platfrom
#packages/apps/Settings frameworks/base 

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Let's sync!
/opt/crave/resync.sh

git clone --depth=1 -b 14.0 https://github.com/zaidanprjkt/device_xiaomi_sm6115-common device/xiaomi/sm6115-common
git clone --depth=1 -b 14.0 https://github.com/zaidanprjkt/vendor_xiaomi_sm6115-common-14 vendor/xiaomi/sm6115-common
git clone --depth=1 -b fourteen https://github.com/zaidanprjkt/vendor_xiaomi_lime-14 vendor/xiaomi/lime
git clone --depth=1 -b u https://github.com/zaidanprjkt/vendor_xiaomi_citrus vendor/xiaomi/citrus
git clone --depth=1 -b ursinia https://github.com/liliumproject/kernel_xiaomi_chime kernel/xiaomi/sm6115

git clone --depth=1 -b cherish https://github.com/zaidanprjkt/device_xiaomi_lime device/xiaomi/lime
git clone --depth=1 -b cherish https://github.com/zaidanprjkt/device_xiaomi_citrus device/xiaomi/citrus

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
export ALLOW_MISSING_DEPENDENCIES=true
export RELAX_USES_LIBRARY_CHECK=true
export BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES=true
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE=true
export BUILD_BROKEN_VERIFY_USES_LIBRARIES=true
export BUILD_BROKEN_USES_BUILD_COPY_HEADERS=true
export BUILD_BROKEN_DUP_RULES=true
export SKIP_ABI_CHECKS=true
export BUILD_BROKEN_INCORRECT_PARTITION_IMAGES=true
#export TARGET_DEFAULT_PIXEL_LAUNCHER=true 

. build/envsetup.sh
brunch lime

brunch citrus


