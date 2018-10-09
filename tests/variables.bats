#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
bin_aws="$bin_path/aws"
PATH="$bin_path:$PATH"
SOURCE_REPO=$(git rev-parse --show-toplevel)

function setup() {
  cd "$SOURCE_REPO"
  mkdir -p $bin_path
  echo 'echo $@' > $bin_docker && chmod +x $bin_docker
  echo 'echo $@' > $bin_aws && chmod +x $bin_aws

  tempdir=$(mktemp -d)
  cp -r ./test_infra "$tempdir"
  cd "$tempdir/test_infra"
  git init -q
  git add .
  git config --local user.email "test@example.com"
  git config --local user.name "test"
  git commit -q -m "initial commit"
  git clone -q "$(pwd)" ../cloned_infra
  cd ../cloned_infra

  unset MASTER_REF LAYERS MODULES CHANGED_LAYERS GIT_BRANCH
  unset LAYERS_DIR MODULES_DIR WORKING_DIR WORKSPACE_DIR
  unset CIRCLE_BRANCH CIRCLE_SHA1
}

function teardown() {
  cd "$SOURCE_REPO"
  rm $bin_docker
  rm $bin_aws
}

@test "uses cached workspace/changed_layers file" {
  mkdir -p ./workspace
  echo layer_one > ./workspace/changed_layers
  echo layer_two >> ./workspace/changed_layers

  source variables.sh
  diff <(echo "$LAYERS") <(printf 'base_network\nroute53_internal_zone\n')
  diff <(echo "$MODULES") <(echo 'shared_code')
  diff <(echo "$CHANGED_LAYERS") <(printf 'layer_one\nlayer_two\n')
}

@test "no changed layers" {
  CIRCLE_BRANCH='not-master'
  echo 'echo' > $bin_aws # fake S3 bucket to have no tf-applied-revision.sha

  source variables.sh
  diff <(echo "$LAYERS") <(printf 'base_network\nroute53_internal_zone\n')
  diff <(echo "$MODULES") <(echo 'shared_code')
  diff <(echo "$CHANGED_LAYERS") <(echo '')
}
