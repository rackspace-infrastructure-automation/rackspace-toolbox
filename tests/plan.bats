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
  diff /tmp/artifacts/terraform_all_plans.log <(echo \
"> Planning layer: base_network
-----------
 + new_resource (at ${TEST_LOCAL_REPO}/layers/base_network)
-----------
> Planning layer: route53_internal_zone
-----------
 + new_resource (at ${TEST_LOCAL_REPO}/layers/route53_internal_zone)
-----------")
  diff /tmp/artifacts/terraform_plan.base_network.log <(echo \
"> Planning layer: base_network
-----------
 + new_resource (at ${TEST_LOCAL_REPO}/layers/base_network)
-----------")
  diff /tmp/artifacts/terraform_plan.route53_internal_zone.log <(echo \
"> Planning layer: route53_internal_zone
-----------
 + new_resource (at ${TEST_LOCAL_REPO}/layers/route53_internal_zone)
-----------")
}

@test "plans includes 'no changes'" {
  mkdir -p ./workspace
  printf 'base_network\n' > ./workspace/changed_layers
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
        echo "Refreshing Terraform state in-memory prior to plan..."
        echo "--------------------"
        echo ""
        echo "No changes. Infrastructure is up-to-date."
        echo ""
        echo "This means that Terraform yada yada yada..."
      fi
    done
  fi
  ' > $bin_terraform

  TF_STATE_BUCKET='le-bucket'
  TF_STATE_REGION='le-region'
  plan.sh

  diff /tmp/artifacts/terraform_all_plans.log <(echo \
"> Planning layer: base_network
--------------------

No changes. Infrastructure is up-to-date.")
  diff /tmp/artifacts/terraform_plan.base_network.log <(echo \
"> Planning layer: base_network
--------------------

No changes. Infrastructure is up-to-date.")
}

@test "fails if plan fails" {
  mkdir -p ./workspace
  printf 'base_network\n' > ./workspace/changed_layers
  TEST_LOCAL_REPO=$(pwd)

  echo '
  echo "$@"
  if [ "$1" = "init" ]; then
    mkdir -p ./.terraform
    echo "$@" > ./.terraform/init
  elif [ "$1" = "plan" ]; then
    exit 1
  fi
  ' > $bin_terraform

  TF_STATE_BUCKET='le-bucket'
  TF_STATE_REGION='le-region'
  run plan.sh

  echo ">> output:"
  echo "$output"
  [ "$status" != 0 ]
}
