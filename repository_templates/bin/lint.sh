#!/bin/sh

set -e

WORKING_DIR=$(pwd)
OVERALL_RETURN=0

# Note: all echo statements will be broken once we run `terraform fmt` -- it
# breaks something with stdout, as described here:
# https://github.com/hashicorp/terraform/issues/16308

for LINT_TYPE in layers modules; do
  LINT_DIR="$WORKING_DIR/$LINT_TYPE"
  if [ ! -d "$LINT_DIR" ]
  then
    continue
  fi

  LINT_NAMES=$(find "$LINT_DIR"/* -type d -maxdepth 0 -exec basename '{}' \; | sort -n)

  for N in $LINT_NAMES; do
    echo "terraform fmt $N"

    LINT_OUTPUT=$(cd "$LINT_DIR/$N" && terraform fmt -check=true -diff=false -write=false -list=true)
    LINT_RETURN=$?

    if [ $LINT_RETURN -ne 0 ]
    then
      echo "Linting failed in $LINT_DIR/$N, please run terraform fmt"
      echo "$LINT_OUTPUT"
      OVERALL_RETURN=1
    fi
  done
done

if [ $OVERALL_RETURN -ne 0 ]
then
  exit $OVERALL_RETURN
fi
