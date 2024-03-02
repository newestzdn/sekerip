# sync rom
repo init -u  -b t13.0 https://github.com/AICP/platform_manifest.git --git-lfs --depth=1
git clone https://github.com/zaidanprjkt/local_manifest.git --depth 1 -b aicp .repo/local_manifests
rm -rf prebuilts/clang/host/linux-x86
#external/chromium-webview
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune
    
# build rom  
source build/envsetup.sh 
lunch aicp_chime-userdebug
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=crave       
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export TZ=Asia/Jakarta 
make bacon -j$(nproc --all)
