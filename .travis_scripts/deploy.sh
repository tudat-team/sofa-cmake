#!/bin/bash


source $BASH_ENV
echo "ANACONDA_USERNAME: ${ANACONDA_USERNAME}"
anaconda login --username "${ANACONDA_USERNAME}" --password "${ANACONDA_PASSWORD}"
echo "CONDA_ARTIFACT: ${CONDA_ARTIFACT}"
# upload to conda -- logout afterwards to release the token and avoid race conditions
# see the comment above where the version is calculated, to understand why both master
# and dev are being pushed.
if [ "${CIRCLE_BRANCH}" == "master" ]; then
  anaconda upload -u tudat-team "${CONDA_ARTIFACT}"
  # Causing an issue currently, will be fixed.
  # anaconda upload -u tudat-team -t "${ANACONDA_TOKEN}" "${CONDA_ARTIFACT}"
  echo "CONDA_ARTIFACT: ${CONDA_ARTIFACT}"
elif [ "${CIRCLE_BRANCH}" == "develop" ]; then
  # Causing an issue currently, will be fixed.
  # anaconda upload -l "dev" -t "${ANACONDA_TOKEN}" -v "${NEW_GIT_TAG}" "${CONDA_ARTIFACT}"
  # anaconda upload -l "dev" -v "${NEW_GIT_TAG}" "${CONDA_ARTIFACT}"
  anaconda upload -u tudat-team -l "dev" "${CONDA_ARTIFACT}"
  echo "NEW_GIT_TAG: ${NEW_GIT_TAG}"
  echo "CONDA_ARTIFACT: ${CONDA_ARTIFACT}"
fi
anaconda logout