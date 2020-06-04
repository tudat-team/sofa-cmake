#!/usr/bin/env bash

mkdir build

# shellcheck disable=SC2164
cd build

cmake \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DSOFA_BUILD_STATIC_LIBRARY=0 \
    ..

make -j16

ctest

make install