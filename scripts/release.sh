#!/usr/bin/env bash

IMAGES_TO_RELEASE=$(cat <<-END
  x86_64 5.5
  x86_64 5.10
  x86_64 5.13
  x86_64 5.15
  x86_64 6.0
  x86_64 6.3
  aarch64 5.5
  aarch64 5.15
  aarch64 6.2
  riscv64 6.3
  mips 5.5
  mips 6.0
END
)

set -e

while IFS= read -r line
do
  ARCH=$(echo "$line" | cut -f 3 -d\ )
  KERNEL=$(echo "$line" | cut -f 4 -d\ )
  echo Bootstrapping $ARCH $KERNEL

  ./scripts/bootstrap.sh $ARCH $KERNEL > /dev/null

  BUILD_DIR="build/${ARCH}_${KERNEL}"
  LOGFILE="./$BUILD_DIR/.log"
  (
    cd "$BUILD_DIR"
    echo "Compiling $ARCH $KERNEL (log in $LOGFILE)"
    make >".log" 2>&1 && echo OK || echo FAILURE
  )

  echo Packing release:
  mkdir -p build/release/
  output="build/release/${ARCH}_${KERNEL}.tar.gz"
  tar czf "$output" -C "$BUILD_DIR/images/" .
  du -sh $output
  echo
done <<< "$IMAGES_TO_RELEASE"
