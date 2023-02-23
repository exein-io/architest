#!/usr/bin/env sh

tempdir="$(mktemp -d)"
echo "Creating files in $tempdir"

set -e

for i in build/*/images;
do
  target=$(basename $(dirname "$i"))
  output="$tempdir/$target.tar.gz"
  tar czf "$output" "$i"
  du -sh $output
done
