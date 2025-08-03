#/usr/bin/env bash
set -e

st_version="0.9.2"

echo "Cleanup..."
rm -Rf ./st-${st_version} ./st-${st_version}.tar.gz

echo "Downloading ST"
curl --progress-bar -LO https://dl.suckless.org/st/st-${st_version}.tar.gz

echo "Extracting ST archive..."
tar xf ./st-${st_version}.tar.gz && rm ./st-${st_version}.tar.gz

echo "Building ST..."
cp ./config-st.h st-${st_version}/config.h
cp ./Makefile-st st-${st_version}/Makefile
cd ./st-${st_version}

make install
cd ../ && rm -Rf ./st-${st_version}

