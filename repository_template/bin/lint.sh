#!/bin/sh

set -e
source ./bin/variables.sh

terraform fmt -check
