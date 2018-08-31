#!/bin/sh

set -e

. $(dirname $(realpath $0))/variables.sh

# in the last hundred commits, is one of the parents in the current master?
set +e
git log --pretty=format:'%H' -n 100 | grep -q "$MASTER_REF"
UPTODATE=$?
set -e

if [ $UPTODATE -ne 0 ]
then
  echo "Your branch is not up to date. Exiting."
  exit 1
fi
