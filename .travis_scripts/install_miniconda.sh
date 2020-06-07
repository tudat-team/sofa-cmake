#!/bin/bash

#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda3
export PATH=$HOME/miniconda3/bin:$PATH
conda init bash
conda update --yes conda  # Update CONDA without command line prompt
#eval "$($HOME/miniconda3/bin/conda shell.bash hook)"