#!/usr/bin/env bats
set -eu

bin_path='/fake-bin'
bin_docker="$bin_path/docker"
bin_aws="$bin_path/aws"
PATH="$bin_path:$PATH"
SOURCE_REPO=$(git rev-parse --show-toplevel)
TFENV_TEST_VERSION="0.11.1"
source "$SOURCE_REPO/tests/bats-utils"

function setup() {
  cd "$SOURCE_REPO"
  fake_command "$bin_docker" "$bin_aws"
  setup_gitrepo
  unset_vars
}

function teardown() {
  cd "$SOURCE_REPO"
  rm "$bin_docker" "$bin_aws"
}

@test "uses cached workspace/changed_layers file" {
  mkdir -p ./workspace
  echo layer_one > ./workspace/changed_layers
  echo layer_two >> ./workspace/changed_layers

  source variables.sh
  diff <(echo "$LAYERS") <(printf 'applicable\nbase_network\nroute53_internal_zone\n')
  diff <(echo "$MODULES") <(echo 'shared_code')
  diff <(echo "$CHANGED_LAYERS") <(printf 'layer_one\nlayer_two\n')
}

@test "when no tf-applied-revision.sha, on branch, without change => no changed layers" {
  echo 'echo' > $bin_aws # aws s3 ls => empty
  CIRCLE_BRANCH='not-master'

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(echo '')
}

@test "when no tf-applied-revision.sha, on master => all layers changed" {
  echo 'echo' > $bin_aws # aws s3 ls => empty
  CIRCLE_BRANCH='master'

  source variables.sh
  diff <(echo "$CHANGED_LAYERS") <(printf 'applicable\nbase_network\nroute53_internal_zone\n')
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

@test "exits with 1 if TF_STATE_BUCKET and TF_STATE_REGION are not set but there are layers" {
  unset TF_STATE_BUCKET
  unset TF_STATE_REGION
  run source variables.sh
  [ "$status" = 1 ]
}

@test "does not exit if TF_STATE_BUCKET and TF_STATE_REGION are not set if there are no layers" {
  unset TF_STATE_BUCKET
  unset TF_STATE_REGION
  rm -r layers
  run source variables.sh
  [ "$status" = 0 ]
}

@test "installs specific terraform successfully if it isn't already, using tfenv" {
  echo "$TFENV_TEST_VERSION" > .terraform-version
  tfenv uninstall $TFENV_TEST_VERSION || echo "v$TFENV_TEST_VERSION was not installed, didn't remove it"

  run source variables.sh
  terraform -version | grep -q "v$TFENV_TEST_VERSION"
}
