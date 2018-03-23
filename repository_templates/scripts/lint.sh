#!/bin/sh

LINT_OUTPUT=$(terraform fmt -check=true -write=false -diff=false -list=true)
LINT_RETURN=$?

if [ ${LINT_RETURN} -ne 0 ]
then
  echo "Linting failed, please run:"
  echo "terraform fmt ${LINT_OUTPUT}"
  exit ${LINT_RETURN}
fi
