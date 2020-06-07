#!/bin/bash

source $BASH_ENV
# export PATH=$HOME/miniconda3/bin:$PATH
echo "CONDA_BUILD_SYSROOT = $CONDA_BUILD_SYSROOT"

# build the library
echo "--- Running build ---"
git submodule update --init --recursive
conda build --no-anaconda-upload .conda
# conda build .conda

# get build artifact path
echo "--- Getting artifact name ---"
conda_artifact=$(conda build --quiet --output .conda)
echo "conda_artifact: $conda_artifact"
printf "export CONDA_ARTIFACT=${conda_artifact}" >> $BASH_ENV ; source $BASH_ENV

# merge the results from all of the tests into a single file for parsing
# echo "--- Saving test results ---"
# mkdir test-reports
# cp /tmp/*-junit.xml test-reports