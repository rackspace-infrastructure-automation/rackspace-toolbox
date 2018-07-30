#!/bin/sh

set -e

# standard paths
WORKING_DIR=$(pwd)
WORKSPACE_DIR="$WORKING_DIR/workspace"
LAYERS_DIR="$WORKING_DIR/layers"

if [ ! -d "$LAYERS_DIR" ]
then
  # don't apply anything if there's no layers directory, we're likely in the
  # common repo here, and shouldn't be running Terraform at all.
  exit
fi


if [ -f "$WORKSPACE_DIR/changed_layers" ]; then
  LAYERS=$(cat "$WORKSPACE_DIR/changed_layers" | sort -n)
else
  LAYERS=$(find "$LAYERS_DIR"/* -type d -maxdepth 0 -exec basename '{}' \; | sort -n)
fi

for LAYER in $LAYERS; do
  # for debugging, show that these files exist
  ls -la "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz"
  ls -la "$WORKSPACE_DIR/terraform.$LAYER.plan"

  # uncache .terraform for the apply
  (cd "$LAYERS_DIR/$LAYER" && tar xzf "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz")

  echo "terraform apply $LAYER"
  (cd "$LAYERS_DIR/$LAYER" && terraform apply -input=false -no-color "$WORKSPACE_DIR/terraform.$LAYER.plan")
done
