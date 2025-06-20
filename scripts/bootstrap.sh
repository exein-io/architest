#!/usr/bin/env bash
#
# Bootstrap a Buildroot out-tree build directory.
#
# Usage:    ./scripts/bootstrap.sh <arch> <kernel-version>
# Example:  ./scripts/bootstrap.sh aarhc64 5.15.185
#
# It:
#   1. checks that the requested arch template exists
#   2. creates   build/<arch>_<ver>/
#   3. runs      make defconfig   there
#   4. substitutes  __CONFIG_FILE__  and  __KERNEL_VERSION__
#      in the arch template and merges it together with
#      fragments/common.frag  (plus any version-specific extra)
#
set -euo pipefail

# Print usage and exit
usage() {
  cat <<EOF
Usage: $0 <architecture> <kernel_version>

Available architectures:
$(for f in fragments/arch/*.frag; do printf '  - %s\n' "${f##*/}"; done)

If you need a specific fragment for <kernel_version>, be sure to have
fragments/linux/<kernel_version>.frag
EOF
  exit 1
}

[[ $# -ne 2 ]] && usage


ARCH="$1"
KVERS="$2"


# KHEADER_VERSION: Extracts the kernel version (W.X) from KVERS (W.X.Y or W.X), then converts dots to underscores.
KVERS_MAJOR=$([[ "$KVERS" == *.*.* ]] && echo "${KVERS%.*}" || echo "$KVERS" )  
KHEADER_VERSION=${KVERS_MAJOR//./_}

COMMON_FRAG="fragments/common.frag"
ARCH_FRAG="fragments/arch/${ARCH}.frag"
EXTRA_FRAG="fragments/linux/${KVERS}.frag"

[[ -r $ARCH_FRAG ]]   || { echo "Unknown arch:  $ARCH"; usage; }

# 2. Prepare and jump into build directory
BUILD_DIR="build/${ARCH}_${KVERS}"
mkdir -p "$BUILD_DIR"
pushd "$BUILD_DIR" >/dev/null

# Buildroot defconfig
make O="$PWD" BR2_EXTERNAL="$(realpath ../../)" -C ../../buildroot/ defconfig


# 3. Create a tmp fragment with correct arch and kernel version
TMP_COMMON_FRAG="$(mktemp)"
# Substitute placeholders in common.frag
sed -e "s/__CONFIG_FILE__/${ARCH}_${KVERS}/" \
    -e "s/__KERNEL_VERSION__/${KVERS//./\\.}/" \
    -e "s/__HEADER_VERSION__/${KHEADER_VERSION}/" \
    "../../${COMMON_FRAG}" > "$TMP_COMMON_FRAG"

# 4. Merge fragemts: common, arch, kernel-version (optional)
merge_list=("${TMP_COMMON_FRAG}" ../../"${ARCH_FRAG}")

[[ -r "../../${EXTRA_FRAG}" ]] && merge_list+=("../../${EXTRA_FRAG}")

../../buildroot/support/kconfig/merge_config.sh "${merge_list[@]}"

# Clean up 
rm -f "$TMP_COMMON_FRAG"
popd >/dev/null

echo
echo "  Config ready in ${BUILD_DIR}/.config"
echo "  cd ${BUILD_DIR} && make          # to build"
