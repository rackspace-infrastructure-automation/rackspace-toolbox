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
        echo "plan yada yada"
        echo "-----------"
        echo " + new_resource (at $(pwd))"
        echo "-----------"
        echo "more yada yada"
      fi
    done
  fi
  ' > $bin_terraform

  TF_STATE_BUCKET='le-bucket'
  TF_STATE_REGION='le-region'
  plan.sh

  diff ./workspace/terraform.base_network.plan <(echo \
"${TEST_LOCAL_REPO}/layers/base_network
init -no-color -input=false -backend=true -backend-config=bucket=le-bucket -backend-config=region=le-region -backend-config=encrypt=true
plan -no-color -input=false -out=${TEST_LOCAL_REPO}/workspace/terraform.base_network.plan")
  diff ./workspace/terraform.route53_internal_zone.plan <(echo \
"${TEST_LOCAL_REPO}/layers/route53_internal_zone
init -no-color -input=false -backend=true -backend-config=bucket=le-bucket -backend-config=region=le-region -backend-config=encrypt=true
plan -no-color -input=false -out=${TEST_LOCAL_REPO}/workspace/terraform.route53_internal_zone.plan")
  diff /tmp/artifacts/terraform_plans.log <(echo \
"> Planning layer: base_network
-----------
 + new_resource (at ${TEST_LOCAL_REPO}/layers/base_network)
-----------
> Planning layer: route53_internal_zone
-----------
 + new_resource (at ${TEST_LOCAL_REPO}/layers/route53_internal_zone)
-----------")
}
