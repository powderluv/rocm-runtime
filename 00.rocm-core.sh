#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-core
cd $ROCM_BUILD_DIR/rocm-core
pushd .

START_TIME=`date +%s`

cmake \
  -DCMAKE_INSTALL_PREFIX=${ROCM_INSTALL_DIR} \
  -DROCM_VERSION=${ROCM_MAJOR_VERSION}.${ROCM_MINOR_VERSION}.${ROCM_PATCH_VERSION} \
  -DPROJECT_VERSION_MAJOR=${ROCM_MAJOR_VERSION} \
  -DPROJECT_VERSION_MINOR=${ROCM_MINOR_VERSION} \
  -DPROJECT_VERSION_PATCH=${ROCM_PATCH_VERSION} \
  -DROCM_PATCH_VERSION=${ROCM_LIBPATCH_VERSION} \
  -DROCM_BUILD_VERSION=${CPACK_DEBIAN_PACKAGE_RELEASE} \
  -B build \
  $ROCM_GIT_DIR/rocm-core

if [[ $1 = "--cmake-install" ]]; then
  echo "Cmake install into ${ROCM_INSTALL_DIR}"
  cmake --build build --target install
else
  echo "deb package install"
  cmake --build build --target package
  sudo dpkg -i *.deb
fi

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

