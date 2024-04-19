# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init --depth=1 -u https://github.com/xdroid-CLO/xd_manifest -b eleven --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel packages/apps/Settings frameworks/base 

git clone -b xd https://github.com/zaidanprjkt/local_manifest .repo/local_manifests

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
git clone --depth=1 -b eleven https://github.com/newestzdn/settings_xd packages/apps/Settings

rm -rf device/xdroid/sepolicy
git clone --depth=1 -b eleven https://github.com/newestzdn/xd_sepolicy device/xdroid/sepolicy

# Do lunch
. build/envsetup.sh
lunch xdroid_juice-user



# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export SELINUX_IGNORE_NEVERALLOWS=false

# Let's start build!
make xd -j$(nproc --all)
