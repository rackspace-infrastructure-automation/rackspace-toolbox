#!/usr/bin/env sh
set -eu

source $(dirname $(realpath $0))/variables.sh

if [ ! -d "$LAYERS_DIR" ]; then
  # don't apply anything if there's no layers directory, we're likely in the
  # common repo here, and shouldn't be running Terraform at all.
  echo "> Not planning, no layers directory were found."
  exit
fi

if [ -z "$CHANGED_LAYERS" ]; then
  echo "> No changed layers to plan."
  exit
fi

for LAYER in $CHANGED_LAYERS; do
  echo "> Planning layer: $LAYER"

  # ensure even deleted layers are plannable
  if [ ! -d "$LAYERS_DIR/$LAYER" ]; then
    echo "> Layer directory $LAYERS_DIR/$LAYER was not found, creating an empty version."
    mkdir -p "$LAYERS_DIR/$LAYER/.terraform"
    touch "$LAYERS_DIR/$LAYER/deleted.tf"
  fi

  pushd "$LAYERS_DIR/$LAYER"
  set -x
  terraform init -no-color -input=false -backend=true -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="region=$TF_STATE_REGION" -backend-config="encrypt=true"

  # cache .terraform during the plan
  tar -czf "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz" .terraform

  terraform plan -no-color -input=false -out="$WORKSPACE_DIR/terraform.$LAYER.plan" | tee /dev/stdout | sed -n '/---/,/---/p' > "$WORKSPACE_DIR/$LAYER.plan.txt"
  set +x
  popd

  # for debugging, show these files exist
  ls -la "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz"
  ls -la "$WORKSPACE_DIR/terraform.$LAYER.plan"
done
