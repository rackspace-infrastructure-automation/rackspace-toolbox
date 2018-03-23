#!/bin/bash

TF_DIRS=$(find . -not -path "*.terraform*" -type f -iname "*.tf*" -exec dirname '{}' \; | sort | uniq)
validate_failed="no"
for DIR in $TF_DIRS
  do
    echo "Processing ${DIR}"
    if ! terraform validate -input=false -check-variables=false -no-color "${DIR}";
      then
        echo "Please run terraform validate ${DIR}"
        validate_failed="yes"
      fi
  done
if [ ${validate_failed} != "no" ]; then exit 1; fi
