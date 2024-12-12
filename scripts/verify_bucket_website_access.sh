#!/bin/bash

BUCKET_NAME="india-to-germany.de-cfa"
S3_WEBSITE_URL="${BUCKET_NAME}.s3-website.eu-central-1.amazonaws.com"

echo "Verifying access to S3 bucket website: ${S3_WEBSITE_URL}"
curl -I "http://${S3_WEBSITE_URL}"
