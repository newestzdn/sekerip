# Simple Script for building ROM, Especially Crave.

# Clean all manifest
rm -rf .repo

# Define variable 
device_codename=chime
rom_name=aicp
build_type=userdebug
do_cleanremove=no

if [ "$rom_name" = "aicp" ]; then
  rom_manifest="https://github.com/AICP/platform_manifest.git"
  branch_rom="t13.0"
  branch_tree="aicp"
  build_command="make bacon"
  version_android="lineage-20.0"
fi

if [ "$rom_name" = "carbon" ]; then
  rom_manifest="https://github.com/CarbonROM/android.git"
  branch_rom="cr-11.0"
  branch_tree="carbon13"
  build_command="make carbon"
  version_android="lineage-20.0"
fi

if [ "$rom_name" = "afterlife" ]; then
  rom_manifest="https://github.com/AfterLifePrjkt13/android_manifest"
  branch_rom="LTS"
  branch_tree="afterlife"
  build_command="m afterlife"
  version_android="lineage-20.0"
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
  version_android="lineage-20.0"
fi

if [ "$rom_name" = "spark" ]; then
  rom_manifest="https://github.com/BuildBots-Den/manifest_spark"
  branch_rom="pyro-next"
  branch_tree="sparkcustom"
  build_command="mka bacon"
  version_android="lineage-20.0"
fi

# Do repo init for rom that we want to build.
repo init -u "${rom_manifest}" -b "${branch_rom}"  --git-lfs --depth=1 --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel packages/resources/devicesettings hardware/xiaomi frameworks/base system/core 

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Clone our local manifest.
git clone https://github.com/zaidanprjkt/local_manifest.git --depth 1 -b $branch_tree .repo/local_manifests

# Let's sync!
/opt/crave/resync.sh

# Use different vendor power, vibrator and clone hardware ximi
rm -rf vendor/qcom/opensource/power
git clone -b arrow-13.1 --depth=1 https://github.com/ArrowOS/android_vendor_qcom_opensource_power vendor/qcom/opensource/power
rm -rf vendor/qcom/opensource/vibrator
git clone -b arrow-13.1 --depth=1 https://github.com/ArrowOS/android_vendor_qcom_opensource_vibrator vendor/qcom/opensource/vibrator
rm -rf hardware/xiaomi
git clone -b thirteen --depth=1 https://github.com/PixelExperience/hardware_xiaomi hardware/xiaomi

# Clone LOS devicesettings for parts.
rm -rf packages/resources/devicesettings
git clone -b "${version_android}" --depth=1 https://github.com/LineageOS/android_packages_resources_devicesettings packages/resources/devicesettings

# Additional some source tree things
rm -rf packages/apps/Settings
git clone -b t13.0 --depth=1 https://github.com/tstprjkt/packages_apps_Settings packages/apps/Settings

rm -rf system/core
git clone -b t13.0 --depth=1 https://github.com/tstprjkt/system_core-aicp system/core

rm -rf frameworks/base
git clone --depth=1 -b t13.0 https://github.com/newestzdn/frameworks_base frameworks/base

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
