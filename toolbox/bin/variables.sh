#!/usr/bin/env sh
set -eu

check_old() {
  local fake_hostname='github.com.original.invalid'
  # avoid overridden ssh config for github.com
  if ! (ssh -G $fake_hostname | grep -q '^hostname github.com$'); then
    echo "Host ${fake_hostname}" >> /etc/ssh/ssh_config
    echo '  HostName github.com' >> /etc/ssh/ssh_config
  fi

  # be sure branch is up to date
  git fetch --quiet --depth 100 $(git config --get remote.origin.url | sed "s/git@github.com:/git@${fake_hostname}:/")

  # in the last hundred commits, is one of the parents in the current master?
  if ! (git log --pretty=format:'%H' -n 100 | grep -q "$(git rev-parse remotes/origin/master)"); then
    echo >&2 'Your branch is not up to date. Exiting...'
    exit 1
  else
    echo 'Your branch is up to date. Proceeding...'
  fi
}

check_old

# standard paths
MASTER_REF=$(git rev-parse remotes/origin/master)
WORKING_DIR=$(pwd)

# ensure workspace dir is always present
WORKSPACE_DIR="$WORKING_DIR/workspace"
mkdir -p "$WORKSPACE_DIR"

# TF_STATE_KEY naming standard: terraform.$LAYER.tfstate
[ -z "$TF_STATE_BUCKET" ] && echo "Missing \$TF_STATE_BUCKET" && exit 1
[ -z "$TF_STATE_REGION" ] && echo "Missing \$TF_STATE_REGION" && exit 1

# populate current module info
MODULES_DIR="$WORKING_DIR/modules"
MODULES=''
if [ -d "$MODULES_DIR" ]; then
  MODULES=$(find "$MODULES_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)

  echo "Modules found: "
  echo $MODULES
fi

find_changed_layers() {
  echo >&2 "Comparing current git revision to: $1"
  git diff --name-only "$1" -- "$LAYERS_DIR" | awk -F "/" '{print $2}' | sort -n | uniq
}

# populate current layer info
LAYERS_DIR="$WORKING_DIR/layers"
LAYERS=''
if [ -d "$LAYERS_DIR" ]; then
  LAYERS=$(find "$LAYERS_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)

  echo "Layers found: "
  echo $LAYERS

  # ensure we know about what layers haved changed
  if [ -f "$WORKSPACE_DIR/changed_layers" ]; then
    CHANGED_LAYERS=$(cat "$WORKSPACE_DIR/changed_layers")
  else
    GIT_BRANCH=${CIRCLE_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
    if ! aws s3 ls s3://${TF_STATE_BUCKET}/tf-applied-revision.sha | grep -q tf-applied-revision.sha; then
      if [ "$GIT_BRANCH" = 'master' ]; then
        echo "No tf-applied-revision.sha file found in s3://${TF_STATE_BUCKET}. Considering all layers changed."
        CHANGED_LAYERS=$LAYERS
      else
        CHANGED_LAYERS=$(find_changed_layers "$MASTER_REF")
      fi
    else
      aws s3 cp "s3://${TF_STATE_BUCKET}/tf-applied-revision.sha" ./last-tf-applied-revision.sha > /dev/null
      CHANGED_LAYERS=$(find_changed_layers "$(cat ./last-tf-applied-revision.sha)")
    fi
    echo $CHANGED_LAYERS > "$WORKSPACE_DIR/changed_layers"
  fi

  echo "Changed layers: "
  echo $CHANGED_LAYERS
fi
