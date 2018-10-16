#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
bin_aws="$bin_path/aws"
PATH="$bin_path:$PATH"
SOURCE_REPO=$(git rev-parse --show-toplevel)
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  mkdir -p $bin_path
  echo 'echo $@' > $bin_docker && chmod +x $bin_docker
  echo 'echo $@' > $bin_aws && chmod +x $bin_aws

  setup_gitrepo

  unset MASTER_REF LAYERS MODULES CHANGED_LAYERS GIT_BRANCH
  unset LAYERS_DIR MODULES_DIR WORKING_DIR WORKSPACE_DIR
  unset CIRCLE_BRANCH CIRCLE_SHA1
}

function teardown() {
  cd "$SOURCE_REPO"
  rm $bin_docker
  rm $bin_aws
}

@test "accepts valid layer" {
  mkdir -p ./workspace
  ls ./layers/ > ./workspace/changed_layers

  lint.sh
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
