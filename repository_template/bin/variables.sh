#!/bin/sh

set -e

# standard paths
WORKING_DIR=$(pwd)

# ensure workspace dir is always present
WORKSPACE_DIR="$WORKING_DIR/workspace"
mkdir -p "$WORKSPACE_DIR"

# be sure branch is up to date
git fetch origin
MASTER_REF=$(git rev-parse remotes/origin/master)

# in the last hundred commits, is one of the parents in the current master?
git log --pretty=format:'%H' -n 100 | grep -q "$MASTER_REF"
UPTODATE=$?

if [ $UPTODATE -ne 0 ]
then
  echo "Your branch is not up to date. Exiting."
  exit 1
fi

# populate current module info
MODULES_DIR="$WORKING_DIR/modules"
if [ -d "$MODULES_DIR" ]
then
  MODULES=$(find "$MODULES_DIR"/* -type d -maxdepth 0 -exec basename '{}' \; | sort -n)

  echo "Modules found: "
  echo $MODULES
fi

# populate current layer info
LAYERS_DIR="$WORKING_DIR/layers"
if [ -d "$LAYERS_DIR" ]
then
  LAYERS=$(find "$LAYERS_DIR"/* -type d -maxdepth 0 -exec basename '{}' \; | sort -n)

  echo "Layers found: "
  echo $LAYERS

  # ensure we know about what layers haved changed
  if [ -f "$WORKSPACE_DIR/changed_layers" ]; then
    CHANGED_LAYERS=$(cat "$WORKSPACE_DIR/changed_layers")
  else
    CHANGED_LAYERS=$(git diff --name-only "$MASTER_REF" -- "$LAYERS_DIR" | awk -F "/" '{print $2}' | sort -n | uniq)
    echo $CHANGED_LAYERS > "$WORKSPACE_DIR/changed_layers"
  fi

  echo "Changed layers: "
  echo $CHANGED_LAYERS
fi
