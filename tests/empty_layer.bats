#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
bin_aws="$bin_path/aws"
bin_terraform="$bin_path/terraform"
PATH="$bin_path:$PATH"
SOURCE_REPO=$(git rev-parse --show-toplevel)
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  fake_command "$bin_docker" "$bin_aws" "$bin_terraform"
  rm -rf ./.terraform.d/
  setup_gitrepo
  unset_vars
}

function teardown() {
  cd "$SOURCE_REPO"
  rm "$bin_docker" "$bin_aws" "$bin_terraform"
}

@test "plan makes empty layer if layer does not exist" {
  mkdir -p ./workspace
  printf 'base_network\ndeleted_layer\n' > ./workspace/changed_layers
  TEST_LOCAL_REPO=$(pwd)

  # ensure base_network looks like a real layer already
  mkdir -p layers/base_network

  echo '
  echo "$@"
  if [ "$1" = "init" ]; then
    mkdir -p ./.terraform
    echo "$@" > ./.terraform/init
  elif [ "$1" = "plan" ]; then
    for arg in $@; do
      if (echo $arg | grep -q "^-out="); then
        output=$(echo $arg | sed "s/^-out=//")
        pwd > "$output"
        cat ./.terraform/init >> "$output"
        echo $@ >> "$output"
      fi
    done
  fi
  ' > $bin_terraform

  TF_STATE_BUCKET='le-bucket'
  TF_STATE_REGION='le-region'
  plan.sh

  # ensure the deleted layer was created
  [ -d "layers/deleted_layer" ]
  [ -d "layers/deleted_layer/.terraform" ]
  [ -f "layers/deleted_layer/deleted.tf" ]

  # ensure the existing layer didn't have special deleted.tf created
  [ ! -f "layers/base_network/deleted.tf" ]
}

@test "apply makes empty layer if layer does not exist" {
  mkdir -p ./workspace
  printf 'deleted_layer\n' > ./workspace/changed_layers
  TEST_LOCAL_REPO=$(pwd)

  # ensure deleted_layer looks like it was planned and tarred up
  mkdir -p layers/deleted_layer/.terraform
  touch layers/deleted_layer/deleted.tf layers/deleted_layer/.terraform/init
  ( cd layers/deleted_layer && tar czvf $TEST_LOCAL_REPO/workspace/.terraform.deleted_layer.tar.gz . )
  touch $TEST_LOCAL_REPO/workspace/terraform.deleted_layer.plan
  rm -rf layers/deleted_layer

  echo '
  echo "$@"
  ' > $bin_terraform

  TF_STATE_BUCKET='le-bucket'
  TF_STATE_REGION='le-region'
  apply.sh

  # ensure the deleted layer was created
  [ -d "layers/deleted_layer" ]
  [ -d "layers/deleted_layer/.terraform" ]
  [ -f "layers/deleted_layer/deleted.tf" ]

  # ensure the existing layer didn't have special empty.tf created
  [ ! -f "layers/base_network/deleted.tf" ]
}
