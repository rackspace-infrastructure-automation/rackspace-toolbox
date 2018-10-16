#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
bin_aws="$bin_path/aws"
PATH="$bin_path:$PATH"
SOURCE_REPO=$(git rev-parse --show-toplevel)
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  mkdir -p $bin_path
  echo 'echo $@' > $bin_docker && chmod +x $bin_docker
  echo 'echo $@' > $bin_aws && chmod +x $bin_aws

  setup_gitrepo

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

@test "when no tf-applied-revision.sha, on branch, without change => no changed layers" {
  echo 'echo' > $bin_aws # aws s3 ls => empty
  CIRCLE_BRANCH='not-master'

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(echo '')
}

@test "when no tf-applied-revision.sha, on master => all layers changed " {
  echo 'echo' > $bin_aws # aws s3 ls => empty
  CIRCLE_BRANCH='master'

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(printf 'base_network\nroute53_internal_zone\n')
}

@test "when no tf-applied-revision.sha, on branch, with change => one changed layer" {
  echo 'echo' > $bin_aws # aws s3 ls => empty
  CIRCLE_BRANCH='not-master'

  echo '# change' >> ./layers/base_network/main.tf
  git add . && git commit -m "change base_network"

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(echo 'base_network')
}

@test "with tf-applied-revision.sha, on branch, with unapplied changes => all changed layers since last apply" {
  echo 'if [ "$1 $2" = "s3 ls" ]; then echo tf-applied-revision.sha; fi' > $bin_aws
  echo 'if [ "$1 $2" = "s3 cp" ]; then echo '"$(git rev-parse HEAD)"' > "$4"; fi' >> $bin_aws
  CIRCLE_BRANCH='anybranch'

  echo '# change' >> ./layers/base_network/main.tf
  git add . && git commit -m "change base_network"
  git push origin

  echo '# change' >> ./layers/route53_internal_zone/main.tf
  git add . && git commit -m "change route53_internal_zone"

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(printf 'base_network\nroute53_internal_zone\n')
}

@test "with tf-applied-revision.sha, on branch, with reverted changes => all changed layers since last apply" {
  echo 'if [ "$1 $2" = "s3 ls" ]; then echo tf-applied-revision.sha; fi' > $bin_aws
  echo 'if [ "$1 $2" = "s3 cp" ]; then echo '"$(git rev-parse HEAD)"' > "$4"; fi' >> $bin_aws
  CIRCLE_BRANCH='anybranch'

  echo '# change' >> ./layers/base_network/main.tf
  git add . && git commit -m "change base_network"
  git push origin

  git revert HEAD -n && git commit -m "revert"

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(echo 'base_network')
}

@test "with tf-applied-revision.sha, on branch, with deleted layer => includes deleted layer in changed list" {
  echo 'if [ "$1 $2" = "s3 ls" ]; then echo tf-applied-revision.sha; fi' > $bin_aws
  echo 'if [ "$1 $2" = "s3 cp" ]; then echo '"$(git rev-parse HEAD)"' > "$4"; fi' >> $bin_aws
  CIRCLE_BRANCH='anybranch'

  rm -r ./layers/base_network/
  git add . && git commit -m "deletes base_network"
  git push origin

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(echo 'base_network')
}
