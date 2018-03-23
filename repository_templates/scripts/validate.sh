#!/bin/sh

TF_DIRS=$(find . -not -path "*.terraform*" -type f -iname "*.tf*" -exec dirname '{}' \; | sort | uniq)
validate_failed="no"
for DIR in $TF_DIRS
  do
    if ! terraform validate -input=false -check-variables=false -no-color "${DIR}";
      then
        echo "Validation failed, please run: terraform validate ${DIR}"
        validate_failed="yes"
      fi
  done
if [ ${validate_failed} != "no" ]; then exit 1; fi
