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

@test "inits and plan" {
  mkdir -p ./workspace
  printf 'base_network\nroute53_internal_zone\n' > ./workspace/changed_layers
  TEST_LOCAL_REPO=$(pwd)

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
  plan.sh

  diff ./workspace/terraform.base_network.plan <(echo \
"${TEST_LOCAL_REPO}/layers/base_network
init -backend=true -backend-config=bucket=le-bucket -backend-config=region=le-region -backend-config=encrypt=true -input=false -no-color
plan -no-color -input=false -out=${TEST_LOCAL_REPO}/workspace/terraform.base_network.plan")
  diff ./workspace/terraform.route53_internal_zone.plan <(echo \
"${TEST_LOCAL_REPO}/layers/route53_internal_zone
init -backend=true -backend-config=bucket=le-bucket -backend-config=region=le-region -backend-config=encrypt=true -input=false -no-color
plan -no-color -input=false -out=${TEST_LOCAL_REPO}/workspace/terraform.route53_internal_zone.plan")
}
