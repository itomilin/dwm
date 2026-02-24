#/usr/bin/env bash
set -e

dwm_version="6.8"
remote_download=0
remove_src=0

echo "Cleanup..."
rm -Rf ./dwm-${dwm_version}

if [[ "$remote_download" -eq 1 ]]; then
  echo "Downloading DWM"
  curl --progress-bar -LO https://dl.suckless.org/dwm/dwm-${dwm_version}.tar.gz
fi

echo "Extracting DWM archive..."
tar xf ./dwm-${dwm_version}.tar.gz

if [[ "$remove_src" -eq 1 ]]; then
  rm -fv ./dwm-${dwm_version}.tar.gz
fi

echo "Building DWM..."
cp ./config-dwm.h dwm-${dwm_version}/config.h
cp ./Makefile-dwm dwm-${dwm_version}/Makefile
cd ./dwm-${dwm_version}

### PATCHES
# rewrite patch with diff -u OriginalFile UpdatedFile > PatchFile

echo "Applying patches..."

echo "pertag >>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-6.1-pertag_without_bar.diff

echo "fullscreen >>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-fullscreen-6.2.diff

# remove borders only for single windows within workspace
echo "uselessgap >>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-uselessgap-20211119-58414bee958f2.diff

echo "attachbottom >>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/attachbottom-6.4.patch

# All floating windows are centered
echo "alwayscenter >>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-alwayscenter-20200625-f04cac6.diff

echo "systray >>>>>>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-systray-6.4.diff

# echo "alttab >>>>>>>>>>>>>>>>>>>>>>>>>>"
# patch -p1 < ../patches/dwm-alttab-6.4.diff

echo "focusonclick >>>>>>>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/dwm-focusonclick-20200110-61bb8b2.diff

echo "rotate stack >>>>>>>>>>>>>>>>>>>>>>>>>>"
patch -p1 < ../patches/rotatestack-patch-new.diff

# echo "STEAM >>>>>>>>>>>>>>>>>>>>>>>>>>"
# patch -p1 < ../patches/dwm-steam-6.2.diff

make install
cd ../ && rm -Rf ./dwm-${dwm_version}


cp -v ./.xinitrc ~/.xinitrc
