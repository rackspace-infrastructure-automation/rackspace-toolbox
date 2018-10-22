#!/usr/bin/env bats
set -eu

SOURCE_REPO=$(git rev-parse --show-toplevel)
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  rm -rf ./.terraform.d/
  setup_gitrepo
  unset_vars
}

function teardown() {
  cd "$SOURCE_REPO"
}

@test "@smoke inits, plans, and applies on a REAL bucket" {
  local expected_revision=$(git rev-parse HEAD)
  local expected_bucket='playground-terraform-toolbox'
  local expected_state_filename="${CIRCLE_USERNAME:-$USER}-${expected_revision}"
  local expected_state_full_path="s3://${expected_bucket}/test_toolbox/${expected_state_filename}.tfstate"
  echo "### Expected state file: ${expected_state_full_path}"

  mkdir -p ./workspace
  echo applicable > ./workspace/changed_layers
  sed -i=bak 's/<%=state_file_name%>/'"${expected_state_filename}/" ./layers/appliable/main.tf

  export TF_STATE_BUCKET="$expected_bucket"
  export TF_STATE_REGION='us-west-2'
  plan.sh

  rm -r ./layers/appliable/.terraform # this directory gets lost in between CircleCI workflow steps

  apply.sh

  echo "### ${expected_state_full_path}:"
  aws s3 cp "${expected_state_full_path}" -
  diff <(aws s3 cp "s3://${expected_bucket}/tf-applied-revision.sha" -) <(echo "$expected_revision")
}
