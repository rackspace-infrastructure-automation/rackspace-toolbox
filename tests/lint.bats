#!/usr/bin/env bats
set -eu -o pipefail

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
bin_aws="$bin_path/aws"
PATH="$bin_path:$PATH"
SOURCE_REPO=$(git rev-parse --show-toplevel)
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  fake_command "$bin_docker" "$bin_aws"
  rm -rf ./.terraform.d/
  setup_gitrepo
  unset_vars
}

function teardown() {
  cd "$SOURCE_REPO"
  rm "$bin_docker" "$bin_aws"
}

@test "accepts valid layer" {
  mkdir -p ./workspace
  ls ./layers/ > ./workspace/changed_layers

  lint.sh
  tuvok
}

@test "rejects invalid layer" {
  mkdir -p ./workspace
  ls ./layers/ > ./workspace/changed_layers

  echo '
resource "random_string" "bad_indentation" {
  length = 99
  special = true
}' >> ./layers/base_network/main.tf

  run lint.sh
  echo ">> output:"
  echo "$output"
  [ "$status" != 0 ]
}
