#!/bin/bash

BUCKET_NAME="india-to-germany.de-cfa"

aws s3api get-public-access-block --bucket $BUCKET_NAME | jq .
