#!/bin/bash -e

# 0 = git, 1 = tar
# https://github.com/pmix/pmix/releases/download/v3.1.4rc2/pmix-3.1.4rc2.tar.gz
_PMIX_IS_TAR=1
_BUILD_PMIX_VERSION=3.1.4
# git clone -b v3.1 https://github.com/pmix/pmix.git pmix-v3.1
#_PMIX_IS_TAR=0
#_BUILD_PMIX_VERSION=v3.1

# 0 = git, 1 = tar
# https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz
_OMPI_IS_TAR=1
_BUILD_OMPI_VERSION=4.0.1
_BUILD_OMPI_BASE_VERSION=4.0
# git clone -b v4.0.x https://github.com/open-mpi/ompi.git openmpi-v4.0.x
#_OMPI_IS_TAR=0
#_BUILD_OMPI_VERSION=v4.0.x


_CONTAINER_BASE_NAME=ompi-base-box:latest
_CONTAINER_NAME=ompi-play-box
_CONTAINER_PMIX_LABEL=pmix_${_BUILD_PMIX_VERSION}
_CONTAINER_OMPI_LABEL=ompi_${_BUILD_OMPI_VERSION}-pmix_${_BUILD_PMIX_VERSION}


echo "========================="
echo "Building the base image"
echo "========================="
time docker build -t ${_CONTAINER_BASE_NAME} -f Dockerfile.base .

echo "========================="
echo "Building the PMIx image"
echo "========================="
if [ 1 -eq $_PMIX_IS_TAR ] ; then
    _PMIX_BUILD_BASE=${_CONTAINER_NAME}:${_CONTAINER_PMIX_LABEL}

    time docker build --build-arg _BUILD_PMIX_VERSION=${_BUILD_PMIX_VERSION} \
         -t ${_PMIX_BUILD_BASE} \
         -f Dockerfile.pmix-tar .
else
    _PMIX_BUILD_BASE=${_CONTAINER_NAME}:${_CONTAINER_PMIX_LABEL}
    
    time docker build --build-arg _BUILD_PMIX_VERSION=${_BUILD_PMIX_VERSION} \
         -t ${_PMIX_BUILD_BASE} \
         -f Dockerfile.pmix-git .
fi

echo "========================="
echo "Building the OMPI image"
echo "========================="
if [ 1 -eq $_OMPI_IS_TAR ] ; then
    time docker build \
         --build-arg _PMIX_BUILD_BASE=${_PMIX_BUILD_BASE} \
         --build-arg _BUILD_OMPI_VERSION=${_BUILD_OMPI_VERSION} \
         --build-arg _BUILD_OMPI_BASE_VERSION=${_BUILD_OMPI_BASE_VERSION} \
         -t ${_CONTAINER_NAME}:${_CONTAINER_OMPI_LABEL} -f Dockerfile.ompi-tar .
else
    time docker build \
         --build-arg _PMIX_BUILD_BASE=${_PMIX_BUILD_BASE} \
         --build-arg _BUILD_OMPI_VERSION=${_BUILD_OMPI_VERSION} \
         -t ${_CONTAINER_NAME}:${_CONTAINER_OMPI_LABEL} -f Dockerfile.ompi-git .
fi

echo "========================="
echo "Final Images"
echo "========================="
docker images ompi-play-box*
