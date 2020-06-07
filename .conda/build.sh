#!/usr/bin/env bash

#sudo apt-get install build-essential cmake

mkdir build

cd build

cmake \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DSOFA_BUILD_STATIC_LIBRARY=1 \
    ..

make -j2

ctest -T Test

# Extract test.xml results to $HOME/tmp/test-reports
mkdir -p $HOME/tmp/test-reports
find ./Testing -name \*.xml -exec cp {} $HOME/tmp/test-reports/test.xml \;

make install