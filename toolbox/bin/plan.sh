#!/usr/bin/env sh
set -eu

source $(dirname $(realpath $0))/variables.sh

if [ ! -d "$LAYERS_DIR" ]; then
  # don't apply anything if there's no layers directory, we're likely in the
  # common repo here, and shouldn't be running Terraform at all.
  echo "> Not planning, no layers directory were found." | tee -a "$WORKSPACE_DIR/full_plan_output.log"
  exit
fi

if [ -z "$CHANGED_LAYERS" ]; then
  echo "> No changed layers to plan." | tee -a "$WORKSPACE_DIR/full_plan_output.log"
  exit
fi

for LAYER in $CHANGED_LAYERS; do
  echo "> Planning layer: $LAYER"

  # ensure even deleted layers are plannable
  if [ ! -d "$LAYERS_DIR/$LAYER" ]; then
    echo "> Layer directory $LAYERS_DIR/$LAYER was not found, creating an empty version." | tee -a "$WORKSPACE_DIR/full_plan_output.log"
    mkdir -p "$LAYERS_DIR/$LAYER/.terraform"
    touch "$LAYERS_DIR/$LAYER/main.tf"
  fi

  set -x
  (cd "$LAYERS_DIR/$LAYER" && terraform init -backend=true -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="region=$TF_STATE_REGION" -backend-config="encrypt=true" -input=false -no-color)
  set +x

  # cache .terraform during the plan
  (cd "$LAYERS_DIR/$LAYER" && tar -czf "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz" .terraform)

  set -x
  (cd "$LAYERS_DIR/$LAYER" && terraform plan -no-color -input=false -out="$WORKSPACE_DIR/terraform.$LAYER.plan" | tee -a "$WORKSPACE_DIR/full_plan_output.log" | grep -v "Refreshing state")
  set +x

  # for debugging, show these files exist
  ls -la "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz"
  ls -la "$WORKSPACE_DIR/terraform.$LAYER.plan"
done
