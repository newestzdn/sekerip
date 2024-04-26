# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init --depth=1 -u https://github.com/protonplus-org/manifest -b tm-qpr3 --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel hardware

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Let's sync!
/opt/crave/resync.sh

git clone https://github.com/zaidanprjkt/device_xiaomi_sm6115-common device/xiaomi/sm6115-common
git clone --depth=1 https://github.com/zaidanprjkt/vendor_xiaomi_sm6115-common vendor/xiaomi/sm6115-common
git clone --depth=1 https://github.com/zaidanprjkt/vendor_xiaomi_lime vendor/xiaomi/lime
git clone https://github.com/zaidanprjkt/device_xiaomi_lime device/xiaomi/lime
git clone --depth=1 https://github.com/frstprjkt/kernel_xiaomi_chime-anya kernel/xiaomi/sm6115

#rm -rf hardware/xiaomi
#git clone --depth=1 -b lineage-20.0 https://github.com/LOSModified/android_hardware_xiaomi hardware/xiaomi

#rm -rf hardware/qcom/sm8250/media
#git clone --depth=1 -b arrow-13.1-caf-sm8250 https://github.com/tstprjkt/android_hardware_qcom_audio hardware/qcom/sm8250/media


#rm -rf hardware/qcom/sm8250/display
#it clone --depth=1 -b arrow-13.1-caf-sm8250 https://github.com/tstprjkt/android_hardware_qcom_display hardware/qcom/sm8250/display

 
# Do lunch
source build/envsetup.sh
lunch lime-user


# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export SELINUX_IGNORE_NEVERALLOWS=false

# Let's start build!
m otapackage -j$(nproc --all)
