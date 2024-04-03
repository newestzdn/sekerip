# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=yes

# Do repo init for rom that we want to build.
repo init -u --depth=1 https://github.com/CorvusOS-Revived/android_manifest.git -b 11 --git-lfs --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel packages/apps/Settings

git clone -b corvus https://github.com/zaidanprjkt/local_manifest .repo/local_manifests

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Let's sync!
/opt/crave/resync.sh

# Do lunch
. build/envsetup.sh
lunch corvus_juice-user

rm -rf packages/apps/Settings
git clone --depth=1 -b patch-1 https://github.com/newestzdn/android_packages_apps_Settings-2 packages/apps/Settings

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

# Let's start build!
mka corvus -j$(nproc --all)
