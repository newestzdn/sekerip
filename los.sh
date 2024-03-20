# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
#device_codename=chime
#rom_name=carbon
#build_type=userdebug
#o_cleanremove=no
#do_smallremove=yes

# Do repo init for rom that we want to build.
#repo init -u "${rom_manifest}" -b "${branch_rom}"  --git-lfs --depth=1 --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel hardware/xiaomi frameworks/base 

# Clone our local manifest.
git clone https://github.com/zaidanprjkt/local_manifest.git --depth 1 -b $branch_tree .repo/local_manifests

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf prebuilts system out prebuilts external hardware packages frameworks
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Let's sync!
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune

# Use different vendor power, vibrator and clone hardware ximi
rm -rf vendor/qcom/opensource/power
git clone -b arrow-13.1 --depth=1 https://github.com/ArrowOS/android_vendor_qcom_opensource_power vendor/qcom/opensource/power
rm -rf vendor/qcom/opensource/vibrator
git clone -b arrow-13.1 --depth=1 https://github.com/ArrowOS/android_vendor_qcom_opensource_vibrator vendor/qcom/opensource/vibrator
#rm -rf hardware/xiaomi
#git clone -b thirteen --depth=1 https://github.com/PixelExperience/hardware_xiaomi hardware/xiaomi


# Clone LOS devicesettings for parts.
#rm -rf packages/resources/devicesettings
#git clone -b "${version_android}" --depth=1 https://github.com/LineageOS/android_packages_resources_devicesettings packages/resources/devicesettings

#rm -rf frameworks/base
#git clone --depth=1 https://github.com/newestzdn/fwb_crb frameworks/base


# Do lunch
. build/envsetup.sh
lunch lineage_chime-userdebug

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=crave       
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority

# Let's start build!
make bacon -j$(nproc --all)
