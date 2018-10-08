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
}

function teardown() {
  cd $(git rev-parse --show-toplevel)
  rm $bin_docker
  rm -r ./test/workspace/
}

@test "uses cached workspace/changed_layers file" {
  rm -rf test/workspace
  mkdir -p test/workspace
  echo layer_one > test/workspace/changed_layers
  echo layer_two >> test/workspace/changed_layers

  cd ./test
  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(echo \
'layer_one
layer_two')
}
