#!/usr/bin/env bash

start=$(date +%s)
echo "$0:start build libwebsockets"

BUILD_DIR="./build"

# start build project
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR
cmake .. -DCMAKE_TOOLCHAIN_FILE=../cross-aarch64-qnx.cmake -DOPENSSL_SSL_LIBRARY=${QNX_TARGET}/aarch64le/usr/lib/ -DOPENSSL_CRYPTO_LIBRARY=${QNX_TARGET}/aarch64le/usr/lib/ -DOPENSSL_INCLUDE_DIR=${QNX_TARGET}/usr/include/openssl -DCMAKE_BUILD_TYPE=RELEASE
make -j4  || exit 1

end=$(date +%s)
take=$((end - start))

cd ..
echo "build project successfully，cost $take s"
