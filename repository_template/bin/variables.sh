#!/bin/sh

set -e

# standard paths
WORKING_DIR=$(pwd)

# ensure workspace dir is always present
WORKSPACE_DIR="$WORKING_DIR/workspace"
mkdir -p "$WORKSPACE_DIR"

# TF_STATE_KEY naming standard: terraform.$LAYER.tfstate
[ -z "$TF_STATE_BUCKET" ] && echo "Missing \$TF_STATE_BUCKET" && exit 1
[ -z "$TF_STATE_REGION" ] && echo "Missing \$TF_STATE_REGION" && exit 1

# populate current module info
MODULES_DIR="$WORKING_DIR/modules"
if [ -d "$MODULES_DIR" ]
then
  MODULES=$(find "$MODULES_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)

  echo "Modules found: "
  echo $MODULES
fi

find_changed_layers() {
  git diff --name-only "$1" -- "$LAYERS_DIR" | awk -F "/" '{print $2}' | sort -n | uniq
}

# populate current layer info
LAYERS_DIR="$WORKING_DIR/layers"
if [ -d "$LAYERS_DIR" ]; then
  LAYERS=$(find "$LAYERS_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)

  echo "Layers found: "
  echo $LAYERS

  # ensure we know about what layers haved changed
  if [ -f "$WORKSPACE_DIR/changed_layers" ]; then
    CHANGED_LAYERS=$(cat "$WORKSPACE_DIR/changed_layers")
  else
    MASTER_REF=$(git rev-parse remotes/origin/master)
    GIT_BRANCH=${CIRCLE_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
    if [ "$GIT_BRANCH" = 'master' ]; then
      if [ -z "$(aws s3 ls s3://${TF_STATE_BUCKET}/tf-applied-revision.sha)" ]; then
        CHANGED_LAYERS=$LAYERS
      else
        REVISION=${CIRCLE_SHA1:-$(git rev-parse HEAD)}
        aws s3 cp "s3://${TF_STATE_BUCKET}/tf-applied-revision.sha" ./last-tf-applied-revision.sha > /dev/null
        CHANGED_LAYERS=$(find_changed_layers "$(cat ./last-tf-applied-revision.sha)")
      fi
    else
      CHANGED_LAYERS=$(find_changed_layers "$MASTER_REF")
    fi
    echo $CHANGED_LAYERS > "$WORKSPACE_DIR/changed_layers"
  fi

  echo "Changed layers: "
  echo $CHANGED_LAYERS
fi
