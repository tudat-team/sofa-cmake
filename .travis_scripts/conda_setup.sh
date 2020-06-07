#!/bin/bash

echo "export PATH=$HOME/miniconda3/bin:$PATH" >> $BASH_ENV ; source $BASH_ENV
conda create --name build_env python=3.7 -y
conda install conda-build -y
conda install anaconda-client -y
conda install conda-verify -y
conda config --add channels conda-forge
conda config --add channels tudat-team
echo "export ANACONDA_ROOT_CHANNEL=team-tudat" >> $BASH_ENV ; source $BASH_ENV
