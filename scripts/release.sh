#!/usr/bin/env bash

IMAGES_TO_RELEASE=$(cat <<-END
  x86_64 5.15.185
  x86_64 6.1.141
  x86_64 6.6.96
  x86_64 6.12.33
  aarch64 5.15.185
  aarch64 6.1.141
  aarch64 6.6.96
  aarch64 6.12.33
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
