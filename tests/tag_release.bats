#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
PATH="$bin_path:$PATH"

function setup() {
  mkdir -p $bin_path
  echo 'echo $@' > $bin_docker
  chmod +x $bin_docker
}

function teardown() {
  rm $bin_docker
}

@test "tags and pushes images" {
  run ./scripts/tag_release fdfdfd 11.22.33
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
  [ ! "$status" = 0 ]
  echo ">> output:"
  echo "$output"
  grep 'parameter not set' -- <(echo "$output")
}
