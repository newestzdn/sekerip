# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
#repo init --depth=1 -u https://github.com/BananaDroid-Revived/android_manifest.git -b 11 --git-lfs --no-repo-verify

repo init --depth=1 -u https://github.com/Havoc-OS-Revived/android_manifest -b eleven --git-lfs --no-repo-verify

#repo init --depth=1 -u https://github.com/xdCLO/xd_manifest -b eleven --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel packages/apps/Settings frameworks/base 

git clone -b los-q https://github.com/zaidanprjkt/local_manifest .repo/local_manifests

#git clone -b xd https://github.com/zaidanprjkt/local_manifest .repo/local_manifests

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Let's sync!
/opt/crave/resync.sh

#repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# Do lunch
. build/envsetup.sh
lunch havoc_juice-user


git clone --depth=1 https://github.com/kdrag0n/proton-clang prebuilts/clang/host/linux-x86/clang-proton

 #havoc 
rm -rf packages/apps/Settings
git clone --depth=1 -b eleven https://github.com/newestzdn/settings-havoc packages/apps/Settings

rm -rf device/havoc/sepolicy
git clone --depth=1 -b eleven https://github.com/zaidannn7/android_device_havoc_sepolicy device/havoc/sepolicy

# banana
#rm -rf packages/apps/Settings
#git clone --depth=1 -b 11 https://github.com/newestzdn/settings_banana packages/apps/Settings

#rm -rf vendor/banana
#git clone --depth=1 -b 11 https://github.com/newestzdn/android_vendor_banana vendor/banana

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export SELINUX_IGNORE_NEVERALLOWS=false

# Let's start build!
m bacon -j$(nproc --all)
