#!/usr/bin/env bats
set -eu -o pipefail

SOURCE_REPO=$(git rev-parse --show-toplevel)
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  rm -f .terraform-version
  setup_gitrepo
  unset_vars
}

function teardown() {
  cd "$SOURCE_REPO"
  rm -f .terraform-version
}

@test "defaults to v0.11.8" {
  run terraform version
  [ "$status" = 0 ]
  echo "$output"
  echo "$output" | grep '^Terraform v0.11.8$'
}

@test "respects .terraform-version with 0.11.7" {
  echo '0.11.7' > .terraform-version

  run terraform version
  [ "$status" = 0 ]
  echo "$output"
  echo "$output" | grep '^Terraform v0.11.7$'
}
