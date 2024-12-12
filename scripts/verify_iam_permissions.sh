#!/bin/bash

# Set variables
IAM_USER_ARN=$(aws iam get-user | jq -r .User.Arn)
BUCKET_NAME="india-to-germany.de-cfa"


# List of actions to verify
ACTIONS=(
  "s3:CreateBucket"
  "s3:PutBucketAcl"
  "s3:PutBucketPolicy"
  "s3:PutObject"
  "s3:GetObject"
  "s3:ListBucket"
)

# Build resource ARNs
BUCKET_ARN="arn:aws:s3:::${BUCKET_NAME}"
OBJECT_ARN="arn:aws:s3:::${BUCKET_NAME}/*"

echo "Simulating permissions for IAM User: ${IAM_USER_ARN}"
echo "Bucket Name: ${BUCKET_NAME}"

# Run simulate-principal-policy for each action
for ACTION in "${ACTIONS[@]}"; do
  echo "Checking permission for action: ${ACTION}"
  
  RESULT=$(aws iam simulate-principal-policy \
    --policy-source-arn "${IAM_USER_ARN}" \
    --action-names "${ACTION}" \
    --resource-arns "${OBJECT_ARN}" \
    --query "EvaluationResults[].[EvalActionName, EvalDecision]" \
    --output text)
  
  if [ $? -ne 0 ]; then
    exit 1
  fi
  
  echo "${RESULT}"
done

echo "Permission verification completed."
