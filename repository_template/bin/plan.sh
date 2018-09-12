#!/bin/sh

set -e

. $(dirname $(realpath $0))/variables.sh

if [ ! -d "$LAYERS_DIR" ]
then
  # don't apply anything if there's no layers directory, we're likely in the
  # common repo here, and shouldn't be running Terraform at all.
  echo "Not planning, no layers were found." > "$WORKSPACE_DIR/full_plan_output.log"
  exit
fi

for LAYER in $CHANGED_LAYERS; do
  echo "terraform init $LAYER"
  (cd "$LAYERS_DIR/$LAYER" && terraform init -backend=true -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="region=$TF_STATE_REGION" -backend-config="encrypt=true" -input=false -no-color)

  # cache .terraform during the plan
  (cd "$LAYERS_DIR/$LAYER" && tar -czf "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz" .terraform)

  echo "terraform plan $LAYER"
  (cd "$LAYERS_DIR/$LAYER" && terraform plan -no-color -input=false -out="$WORKSPACE_DIR/terraform.$LAYER.plan" | tee -a "$WORKSPACE_DIR/full_plan_output.log" | grep -v "Refreshing state" )

  # for debugging, show these files exist
  ls -la "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz"
  ls -la "$WORKSPACE_DIR/terraform.$LAYER.plan"
done
