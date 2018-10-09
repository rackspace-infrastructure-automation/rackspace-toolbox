#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
PATH="$bin_path:$PATH"

function setup() {
  cd $(git rev-parse --show-toplevel)
  mkdir -p $bin_path
  echo 'echo $@' > $bin_docker
  chmod +x $bin_docker

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
}

function teardown() {
  cd $(git rev-parse --show-toplevel)
  rm $bin_docker
}

@test "uses cached workspace/changed_layers file" {
  mkdir -p ./workspace
  echo layer_one > ./workspace/changed_layers
  echo layer_two >> ./workspace/changed_layers

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(printf 'layer_one\nlayer_two\n')
  diff <(echo "$LAYERS") <(printf 'base_network\nroute53_internal_zone\n')
  diff <(echo "$MODULES") <(echo 'shared_code')
}

@test "no changed layers" {
  mkdir -p ./workspace
  echo layer_one > ./workspace/changed_layers
  echo layer_two >> ./workspace/changed_layers

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(printf 'layer_one\nlayer_two\n')
  diff <(echo "$LAYERS") <(printf 'base_network\nroute53_internal_zone\n')
  diff <(echo "$MODULES") <(echo 'shared_code')
}
