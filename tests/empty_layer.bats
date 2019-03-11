#!/usr/bin/env bats
set -eu -o pipefail

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
  printf 'deleted_layer\n' > ./workspace/changed_layers

  TF_STATE_BUCKET='le-bucket' TF_STATE_REGION='le-region' plan.sh

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

  mkdir .terraform
  echo 'init-data' > .terraform/init
  tar -czf ./workspace/.terraform.deleted_layer.tar.gz .terraform
  rm -r .terraform
  echo 'fake-plan' > workspace/terraform.deleted_layer.plan

  TF_STATE_BUCKET='le-bucket' TF_STATE_REGION='le-region' apply.sh

  # ensure the deleted layer was created
  [ -d "layers/deleted_layer" ]
  [ -d "layers/deleted_layer/.terraform" ]
  [ -f "layers/deleted_layer/deleted.tf" ]

  # ensure the existing layer didn't have special deleted.tf created
  [ ! -f "layers/base_network/deleted.tf" ]
}
