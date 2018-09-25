#!/bin/sh

set -e

. $(dirname $(realpath $0))/variables.sh

terraform fmt -check -diff
