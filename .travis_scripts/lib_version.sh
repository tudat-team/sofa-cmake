#!/bin/bash

version=$(cat version)
# We update the version number on the dev branch. This ensures that master never gets ahead of dev
# In order to control this, when we push to anaconda, we use the label 'dev' for the dev branch
# and no label for the master branch. Thus when installing, a user will only get the dev versions
# if they explictly ask for that label.
if [ "${CIRCLE_BRANCH}" != "master" ]; then
  if [ "${CIRCLE_BRANCH}" == "develop" ]; then
    #version=$(cat version | perl -pe 's/^((\d+\.)*)(\d+)(.*)$/$1.($3+1).$4/e')
    version=$(cat version | perl -pe 's/^((\d+\.)*)(\d+)(.*)$/$1.($3+1).$4/e')
  else
    # add the branch name, but remove any dashes to make it fit with PEP-440
    version="${version}+${CIRCLE_BRANCH//-/}"
  fi
  version="${version//\//}"  # also remove slashes!
  printf ${version} > version
fi
# set up environment variables
printf 'export VERSION=%s\n' "${version}" >> $BASH_ENV
if [ "${CIRCLE_BRANCH}" == "develop" ]; then
  printf 'export NEW_GIT_TAG=%s+dev\n' "${version}" >> $BASH_ENV
  printf 'export ANACONDA_CHANNEL=${ANACONDA_ROOT_CHANNEL}/label/dev\n' >> $BASH_ENV
else
  printf 'export NEW_GIT_TAG=%s\n' "${version}" >> $BASH_ENV
  printf 'export ANACONDA_CHANNEL=${ANACONDA_ROOT_CHANNEL}\n' >> $BASH_ENV
fi
# printf 'export DOCKER_IMAGE=%s/%s\n' "${CIRCLE_PROJECT_USERNAME}" "${CIRCLE_PROJECT_REPONAME}" >> $BASH_ENV
# make sure to switch the '+' (needed for python) to a '.' (needed for docker)
# printf 'export DOCKER_FLAG=${DOCKER_IMAGE}:${NEW_GIT_TAG//+/.}\n' >> $BASH_ENV
source $BASH_ENV