#!/bin/sh

list_options() {
  for i in $(ls $1)
  do
    echo "- $(basename $i .frag)"
  done
}

usage() {
	echo "Usage: $0 <architecture> <linux_version>"
	echo
  echo "Available architectures:"
  list_options fragments/arch/
	echo
  echo "Available linux versions:"
  list_options fragments/linux/
}

if [ "$#" -lt 2 ] ; then
	usage
	exit
fi

ARCH="$1"
ARCH_FILE="fragments/arch/${ARCH}.frag"
LINUX_VERSION="$2"
LINUX_VERSION_FILE="fragments/linux/${LINUX_VERSION}.frag"

if [ ! -r "${ARCH_FILE}" ] ; then
  echo "Architecture ${ARCH} not available"
  echo "Create ${ARCH_FILE} or pick one among"
  list_options fragments/arch/
  exit
fi
if [ ! -r "${LINUX_VERSION_FILE}" ] ; then
  echo "Linux ${LINUX_VERSION} not available"
  echo "Create ${LINUX_VERSION_FILE} or pick one among"
  list_options fragments/linux/
  exit
fi

BUILD_DIR="build/${ARCH}_${LINUX_VERSION}"

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"
make O=$PWD BR2_EXTERNAL=$(realpath ../../) -C ../../buildroot/ defconfig
../../buildroot/support/kconfig/merge_config.sh \
 "../../fragments/common.frag" \
 "../../${ARCH_FILE}" \
 "../../${LINUX_VERSION_FILE}"
