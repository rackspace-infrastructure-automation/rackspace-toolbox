#!/usr/bin/env sh
set -eu

. $(dirname $(realpath $0))/variables.sh

terraform fmt -check -diff
tuvok . || exit 0 # don't fail builds yet
