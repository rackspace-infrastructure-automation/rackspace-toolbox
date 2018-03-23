#!/bin/bash

LINT_OUTPUT=$(terraform fmt -check=true -write=false -diff=false -list=true)
LINT_RETURN=$?

if [ $? -eq 0 ]
then
  echo "Please run terraform fmt on:"
  echo "${LINT_OUTPUT}"
fi
