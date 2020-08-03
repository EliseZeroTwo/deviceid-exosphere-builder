#!/bin/bash

if [[ -z $DEVICEID ]]; then
    echo Missing ENV var DEVICEID
    exit 1
fi

if [[ ! -d "/output" ]]; then
    echo "Missing '/output' directory. Mount it as a docker volume"
    exit 1
fi

sed -i "/u64 GetDeviceId() {/ s/$/ return $DEVICEID;/" ../libraries/libexosphere/source/fuse/fuse_api.cpp
rm -rf ../libraries/libexosphere/lib_nintendo_nx_arm
rm -rf ../libraries/libexosphere/lib_nintendo_nx_arm64
rm ../libraries/libexosphere/build_nintendo_nx_arm/fuse_api.*
rm ../libraries/libexosphere/build_nintendo_nx_arm64/fuse_api.*

make -j$(nproc) exosphere.bin

cp ./exosphere.bin /output/deviceid_exosphere.bin