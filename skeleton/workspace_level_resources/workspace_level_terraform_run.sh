#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [plan|apply|destroy]"
  exit 1
fi

ACTION="$1"

if [[ "$ACTION" != "apply" && "$ACTION" != "destroy" && "$ACTION" != "plan" ]]; then
  echo "Invalid argument: $ACTION"
  echo "Usage: $0 [plan|apply|destroy]"
  exit 1
fi

# Path to your YAML config
CONFIG_FILE="../config/default.yml"

# Ensure yq is installed
if ! command -v yq &> /dev/null; then
  echo "Error: yq is not installed. Install it from https://github.com/mikefarah/yq/"
  exit 1
fi

# Read workspaces from YAML and loop
yq e '.workspaces[].name' "$CONFIG_FILE" | while read -r WORKSPACE_NAME; do
  echo "Processing workspace: $WORKSPACE_NAME"
  echo "key=$TF_STATE_KEY/$WORKSPACE_NAME/terraform.tfstate" 
  export TF_VAR_workspace_name="$WORKSPACE_NAME"
  # Run terraform init
  terraform init \
    -backend-config="bucket=$TF_BACKEND_BUCKET" \
    -backend-config="key=$TF_STATE_KEY/$WORKSPACE_NAME/terraform.tfstate" \
    -backend-config="region=$AWS_REGION" \
    -input=false \
    -reconfigure \
    -upgrade


  case "$ACTION" in
    plan)
      terraform plan
      ;;
    apply)
      terraform apply  --auto-approve
      ;;
    destroy)
      terraform destroy --auto-approve
      ;;
  esac
done