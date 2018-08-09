#!/bin/sh

set -e
source ./bin/variables.sh

for LAYER in $CHANGED_LAYERS; do
  # for debugging, show that these files exist
  ls -la "$LAYERS_DIR/$LAYER/terraform.tfstate"

  # uncache .terraform for the destroy
  (cd "$LAYERS_DIR/$LAYER" && tar xzf "$WORKSPACE_DIR/.terraform.$LAYER.tar.gz" || echo "Did not find a cached .terraform directory")

  echo "terraform destroy $LAYER"
  (cd "$LAYERS_DIR/$LAYER" && terraform destroy -refresh=false -auto-approve)
done
