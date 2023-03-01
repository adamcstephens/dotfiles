#!/usr/bin/env sh

[ -z $1 ] && echo "Must specify PR" && exit
pr="$1"

trap "echo Exited!; exit;" SIGINT SIGTERM

set -ex

for arch in x86_64-linux aarch64-linux aarch64-darwin x86_64-darwin; do
  time nixpkgs-review pr --run "cat report.md" --system $arch "$pr"
done
