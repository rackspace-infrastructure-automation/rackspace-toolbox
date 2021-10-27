#!/usr/bin/env sh
set -eu -o pipefail

source $(dirname $(realpath $0))/variables.sh

# this is done for backward compatibility to builds that are specifically including full_plan_output.log in persist_to_workspace
touch "$WORKSPACE_DIR/full_plan_output.log"

mkdir -p /tmp/artifacts/
ALL_OUTPUT="/tmp/artifacts/terraform_all_outputs.log"

if [ ! -d "$LAYERS_DIR" ]; then
  # don't apply anything if there's no layers directory, we're likely in the
  # common repo here, and shouldn't be running Terraform at all.
  echo "> Not planning, no layers directory were found." | tee -a "$ALL_OUTPUT"
  exit
fi
if [ -z "$CHANGED_LAYERS" ]; then
  echo "> No changed layers to plan." | tee -a "$ALL_OUTPUT"
  exit
fi

for LAYER in $CHANGED_LAYERS; do
  ALL_PLANS="/tmp/artifacts/terraform_all_plans.log"
  LAYER_OUTPUT="/tmp/artifacts/terraform_output.${LAYER}.log"
  LAYER_PLAN="/tmp/artifacts/terraform_plan.${LAYER}.log"
  echo "> Planning layer: $LAYER" | tee -a "$ALL_OUTPUT" "$ALL_PLANS" "$LAYER_OUTPUT" "$LAYER_PLAN"

  # ensure even deleted layers are plannable
  if [ ! -d "$LAYERS_DIR/$LAYER" ]; then
    echo "> Layer directory $LAYERS_DIR/$LAYER was not found, creating an empty version." | tee -a "$ALL_OUTPUT" "$ALL_PLANS" "$LAYER_OUTPUT" "$LAYER_PLAN"
    mkdir -p "$LAYERS_DIR/$LAYER/.terraform"
    touch "$LAYERS_DIR/$LAYER/deleted.tf"
  fi

  cd "$LAYERS_DIR/$LAYER"
  (set -x && terraform init -no-color -input=false -backend=true -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="region=$TF_STATE_REGION" -backend-config="encrypt=true") \
     | tee -a "$ALL_OUTPUT" "$LAYER_OUTPUT"

  # cache .terraform during the plan
  tar -czf "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz" .terraform* | tee -a "$ALL_OUTPUT" "$LAYER_OUTPUT"


  TEMP_PLAN_LOG=$(mktemp)
  (set -x && terraform plan -no-color -input=false -out="$WORKSPACE_DIR/terraform.$LAYER.plan") | tee -a "$TEMP_PLAN_LOG" | grep -v "Refreshing state"
  cat "$TEMP_PLAN_LOG" | tee -a "$ALL_OUTPUT" "$LAYER_OUTPUT" | sed -n '/-----/,/-----/p'  | sed -n '/-----/,/No changes. Infrastructure is up-to-date/p' \
    | tee -a "$ALL_PLANS" "$LAYER_PLAN" > /dev/null
done
