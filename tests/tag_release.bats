#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
PATH="$bin_path:$PATH"
SOURCE_REPO=$(git rev-parse --show-toplevel)
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  fake_command "$bin_docker"
}

function teardown() {
  cd "$SOURCE_REPO"
  rm "$bin_docker"
}

@test "tags and pushes images" {
  run ./scripts/tag_release fdfdfd 11.22.33
  echo ">> output:"
  echo "$output"
  [ "$status" = 0 ]
  diff <(echo "$output") <(echo \
'pull rackautomation/rackspace-toolbox:fdfdfd
tag rackautomation/rackspace-toolbox:fdfdfd rackautomation/rackspace-toolbox:latest
push rackautomation/rackspace-toolbox:latest
tag rackautomation/rackspace-toolbox:fdfdfd rackautomation/rackspace-toolbox:11.22.33
push rackautomation/rackspace-toolbox:11.22.33
tag rackautomation/rackspace-toolbox:fdfdfd rackautomation/rackspace-toolbox:11.22
push rackautomation/rackspace-toolbox:11.22
tag rackautomation/rackspace-toolbox:fdfdfd rackautomation/rackspace-toolbox:11
push rackautomation/rackspace-toolbox:11')
}

@test "requires two args" {
  run ./scripts/tag_release fdfdfd
  echo ">> output:"
  echo "$output"
  [ ! "$status" = 0 ]
  grep 'parameter not set' -- <(echo "$output")
}

@test "escape slashes" {
  run ./scripts/tag_release fdfdfd branch_king/test/z
  echo ">> output:"
  echo "$output"
  [ "$status" = 0 ]
  diff <(echo "$output") <(echo \
'pull rackautomation/rackspace-toolbox:fdfdfd
tag rackautomation/rackspace-toolbox:fdfdfd rackautomation/rackspace-toolbox:latest
push rackautomation/rackspace-toolbox:latest
tag rackautomation/rackspace-toolbox:fdfdfd rackautomation/rackspace-toolbox:branch_king_test_z
push rackautomation/rackspace-toolbox:branch_king_test_z')
}
