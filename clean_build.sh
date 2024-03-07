#/bin/bash
set -e

echo "Clean old files..."
rm -Rf ./dwm-6.4

echo "Extract archive..."
tar xf ./dwm-6.4.tar.gz

echo "Copy and build..."
cp ./config.h ./Makefile dwm-6.4/
cd ./dwm-6.4

### PATCHES
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
###

make clean install
rm -Rf ./dwm-6.4

