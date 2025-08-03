#/usr/bin/env bash
set -e

dwm_version="6.5"

echo "Cleanup..."
rm -Rf ./dwm-${dwm_version} ./dwm-${dwm_version}.tar.gz

echo "Downloading DWM"
curl --progress-bar -LO https://dl.suckless.org/dwm/dwm-${dwm_version}.tar.gz

echo "Extracting DWM archive..."
tar xf ./dwm-${dwm_version}.tar.gz && rm ./dwm-${dwm_version}.tar.gz

echo "Building DWM..."
cp ./config-dwm.h dwm-${dwm_version}/config.h
cp ./Makefile-dwm dwm-${dwm_version}/Makefile
cd ./dwm-${dwm_version}

### PATCHES
# rewrite patch with diff -u OriginalFile UpdatedFile > PatchFile

echo "Applying patches..."

echo "fullscreen >>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-fullscreen-6.2.diff

echo "uselessgap >>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-uselessgap-20211119-58414bee958f2.diff

echo "attachbottom >>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/attachbottom-6.4.patch

echo "alwayscenter >>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-alwayscenter-20200625-f04cac6.diff

echo "systray >>>>>>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-systray-6.4.diff

#echo "alttab >>>>>>>>>>>>>>>>>>>>>>>>>>"
#patch -p1 < ../patches/dwm-alttab-6.4.diff

echo "focusonclick >>>>>>>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-focusonclick-20200110-61bb8b2.diff

echo "rotate stack >>>>>>>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/rotatestack-patch-new.diff

echo "STEAM >>>>>>>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-steam-6.2.diff

make install
cd ../ && rm -Rf ./dwm-${dwm_version}

