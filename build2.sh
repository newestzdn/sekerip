# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init --depth=1 -u https://github.com/BananaDroid-Revived/android_manifest.git -b 11 --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device/xiaomi vendor/xiaomi kernel/xiaomi hardware/xiaomi 
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

git clone -b banana https://github.com/zaidanprjkt/device_xiaomi_juice device/xiaomi/juice
git clone -b eleven https://github.com/zaidanprjkt/android_vendor_xiaomi_juice vendor/xiaomi/juice
git clone -b main https://github.com/greenforce-project/kernel_xiaomi_citrus_sm6115 kernel/xiaomi/juice

rm -rf packages/apps/Settings
git clone --depth=1 -b 11 https://github.com/newestzdn/settings_banana packages/apps/Settings

rm -rf vendor/banana
git clone --depth=1 -b 11 https://github.com/newestzdn/android_vendor_banana vendor/banana

#rm -rf external/chromium-webview/patches

# Do lunch
. build/envsetup.sh

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
#export SELINUX_IGNORE_NEVERALLOWS=true
export ALLOW_MISSING_DEPENDENCIES=true
export RELAX_USES_LIBRARY_CHECK=true
export BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES=true
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE=true
export BUILD_BROKEN_VERIFY_USES_LIBRARIES=true
export BUILD_BROKEN_USES_BUILD_COPY_HEADERS=true
export BUILD_BROKEN_DUP_RULES=true
export SKIP_ABI_CHECKS=true
#export BUILD_BROKEN_INCORRECT_PARTITION_IMAGES=true
#export TARGET_DEFAULT_PIXEL_LAUNCHER=true 

lunch banana_juice-user
make banana

