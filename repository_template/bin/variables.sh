#!/bin/sh

set -e

# standard paths
WORKING_DIR=$(pwd)

# ensure workspace dir is always present
WORKSPACE_DIR="$WORKING_DIR/workspace"
mkdir -p "$WORKSPACE_DIR"

# populate current module info
MODULES_DIR="$WORKING_DIR/modules"
if [ -d "$MODULES_DIR" ]
then
  MODULES=$(find "$MODULES_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)

  echo "Modules found: "
  echo $MODULES
fi

# populate current layer info
LAYERS_DIR="$WORKING_DIR/layers"
if [ -d "$LAYERS_DIR" ]
then
  LAYERS=$(find "$LAYERS_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)

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
