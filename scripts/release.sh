#!/usr/bin/env sh

tempdir="$(mktemp -d)"
echo "Creating files in $tempdir"

set -e
set -x

for i in build_*;
do
  tar czf "$tempdir/$i.tar.gz" $i/images
done
