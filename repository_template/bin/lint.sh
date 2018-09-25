#!/bin/sh

set -e

# be sure branch is up to date
git fetch origin
MASTER_REF=$(git rev-parse remotes/origin/master)

# in the last hundred commits, is one of the parents in the current master?
if ! (git log --pretty=format:'%H' -n 100 | grep -q "$MASTER_REF"); then
  echo >&2 'Your branch is not up to date. Exiting.'
  exit 1
fi

. $(dirname $(realpath $0))/variables.sh

terraform fmt -check -diff
