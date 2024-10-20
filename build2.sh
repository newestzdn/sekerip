# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
device_codename=juice
rom_name=lineage
build_type=user


# Do repo init for rom that we want to build.
repo init -u https://github.com/LineageOS-Revived/android -b lineage-18.1  --git-lfs --depth=1 --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel packages/resources/devicesettings system/core 

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Clone our local manifest.
git clone https://github.com/Glamoth-Firnament/device_xiaomi_juice-R -b los device/xiaomi/juice
git clone -b eleven https://github.com/zaidanprjkt/android_vendor_xiaomi_juice vendor/xiaomi/juice

# Let's sync!
/opt/crave/resync.sh

# Use different vendor power, vibrator and clone hardware ximi
#rm -rf vendor/qcom/opensource/power
#git clone -b arrow-13.1 --depth=1 https://github.com/ArrowOS/android_vendor_qcom_opensource_power vendor/qcom/opensource/power
#rm -rf vendor/qcom/opensource/vibrator
#git clone -b arrow-13.1 --depth=1 https://github.com/ArrowOS/android_vendor_qcom_opensource_vibrator vendor/qcom/opensource/vibrator
#rm -rf hardware/xiaomi
#git clone -b thirteen --depth=1 https://github.com/PixelExperience/hardware_xiaomi hardware/xiaomi

# Clone LOS devicesettings for parts.
#rm -rf packages/resources/devicesettings
#git clone -b "${version_android}" --depth=1 https://github.com/LineageOS/android_packages_resources_devicesettings packages/resources/devicesettings

# Additional some source tree things

# Do lunch
. build/envsetup.sh
lunch lineage_juice-user

# Allow neverallow if userdebug
#xport SELINUX_IGNORE_NEVERALLOWS=true

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority    
export SKIP_ABI_CHECKS=true
export ALLOW_MISSING_DEPENDENCIES=true
export RELAX_USES_LIBRARY_CHECK=true
export BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES=true
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE=true
export BUILD_BROKEN_VERIFY_USES_LIBRARIES=true
export BUILD_BROKEN_USES_BUILD_COPY_HEADERS=true
export BUILD_BROKEN_DUP_RULES=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export BUILD_BROKEN_INCORRECT_PARTITION_IMAGES=true

# Let's start build!
mka bacon
