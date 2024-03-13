# Simple Script for building ROM, Especially Crave.
# For Personal only, but you can fork and use it.
# Copyright (C) 2023 newestzdn

rm -rf project

# Define variable 
device_codename=chime
rom_name=spark
build_type=userdebug
#rom_manifest="https://github.com/Miku-UI/manifesto"
#branch_rom=TDA
#branch_tree=miku
#build_command="make diva"

if [ "$rom_name" = "miku" ]; then
  rom_manifest="https://github.com/newestzdn/manifesto"
  branch_rom="TDA"
  branch_tree="miku"
  build_command="make diva"
  export MIKU_GAPPS=false
fi

if [ "$rom_name" = "baikal" ]; then
  rom_manifest="https://github.com/baikalos/android.git"
  branch_rom="13.0"
  branch_tree="baikal"
  build_command="m bacon"
fi

if [ "$rom_name" = "aicp" ]; then
  rom_manifest="https://github.com/AICP/platform_manifest.git"
  branch_rom="t13.0"
  branch_tree="aicp"
  build_command="make bacon"
fi

if [ "$rom_name" = "afterlife" ]; then
  rom_manifest="https://github.com/AfterLifePrjkt13/android_manifest"
  branch_rom="LTS"
  branch_tree="afterlife"
  build_command="m afterlife"
fi

if [ "$rom_name" = "plros" ]; then
  rom_manifest="https://github.com/plros/manifests.git"
  branch_rom="lineage-20.0"
  branch_tree="plros"
  build_command="m bacon"
fi

if [ "$rom_name" = "lmodroid" ]; then
  rom_manifest="https://github.com/burhancodes/lmodroid"
  branch_rom="thirteen"
  branch_tree="lmodroid"
  build_command="m bacon"
fi

if [ "$rom_name" = "spark" ]; then
  rom_manifest="https://github.com/BuildBots-Den/manifest_spark"
  branch_rom="pyro-next"
  branch_tree="sparkcustom"
  build_command="mka bacon"
fi

# Do repo init for rom that we want to build.
repo init -u "${rom_manifest}" -b "${branch_rom}"  --git-lfs --depth=1 --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel

# Clone our local manifest.
git clone https://github.com/zaidanprjkt/local_manifest.git --depth 1 -b $branch_tree .repo/local_manifests

# Do remove here before repo sync.
rm -rf system out prebuilts external hardware packages frameworks

# Let's sync!
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune

#it clone https://github.com/frstprjkt/kernel_xiaomi_chime-anya kernel/xiaomi/chime

# Uh
rm -rf packages/providers/DownloadProvider
git clone --depth=1 https://github.com/ArrowOS/android_packages_providers_DownloadProvider packages/providers/DownloadProvider

# Use different vendor-power
rm -rf vendor/qcom/opensource/power
git clone -b arrow-13.1 --depth=1 https://github.com/ArrowOS/android_vendor_qcom_opensource_power vendor/qcom/opensource/power

rm -rf packages/resources/devicesettings
git clone -b lineage-20.0 --depth=1 https://github.com/LineageOS/android_packages_resources_devicesettings packages/resources/devicesettings

rm -rf vendor/qcom/opensource/vibrator
git clone -b arrow-13.1 https://github.com/ArrowOS/android_vendor_qcom_opensource_vibrator vendor/qcom/opensource/vibrator

rm -rf hardware/xiaomi
git clone -b lineage-20 --depth=1 https://github.com/LineageOS/android_hardware_xiaomi hardware/xiaomi

#rm -rf packages/apps/Settings
#git clone -b patch-1 --depth=1 https://github.com/newestzdn/android_packages_apps_Settings packages/apps/Settings

#rm -rf frameworks/base
#git clone -b patch-1 --depth=1 https://github.com/newestzdn/android_frameworks_base frameworks/base

# Do lunch
. build/envsetup.sh
lunch "${rom_name}"_"${device_codename}"-userdebug

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=crave       
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority

# Let's start build!
$build_command -j$(nproc --all)
