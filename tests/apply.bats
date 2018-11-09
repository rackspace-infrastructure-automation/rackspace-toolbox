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

@test "applies" {
  mkdir -p ./workspace
  echo base_network > ./workspace/changed_layers
  TEST_LOCAL_REPO=$(pwd)

  echo '
  echo "$@"
  output='"$TEST_LOCAL_REPO/terraform-output"'
  pwd > "$output"
  cat ./.terraform/init >> "$output"
  echo $@ >> "$output"
  ' > $bin_terraform

  echo '
  echo "$@"
  output='"$TEST_LOCAL_REPO/aws-output"'
  echo $@ >> "$output"
  if [ "$1 $2" = "s3 cp" ]; then
    cat "$3" >> "$output"
  fi
  ' > $bin_aws

  mkdir .terraform
  echo 'init-data' > .terraform/init
  tar -czf ./workspace/.terraform.base_network.tar.gz .terraform
  rm -r .terraform
  echo 'fake-plan' > workspace/terraform.base_network.plan

  TF_STATE_BUCKET='stateful-bucket' CIRCLE_SHA1='aabbccbacbacbacbac' apply.sh

  diff "$TEST_LOCAL_REPO/terraform-output" <(echo \
"${TEST_LOCAL_REPO}/layers/base_network
init-data
apply -input=false -no-color ${TEST_LOCAL_REPO}/workspace/terraform.base_network.plan")

  diff "$TEST_LOCAL_REPO/aws-output" <(echo \
'configure list
s3 cp ./tf-applied-revision.sha s3://stateful-bucket/
aabbccbacbacbacbac')
}
