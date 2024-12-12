#!/bin/bash

BUCKET_NAME="india-to-germany.de-cfa"
DOMAIN_NAME="indiatogermany.de"
WWW_SUBDOMAIN="www.${DOMAIN_NAME}"
EXPECTED_ENDPOINT="${BUCKET_NAME}.s3-website.eu-central-1.amazonaws.com"

function test_dns_resolution() {
  local domain=$1
  echo "Testing DNS resolution: ${domain}"
  
  resolved_ip=$(dig +short ${domain})
  
  if [[ -z "${resolved_ip}" ]]; then
    echo "ERROR: Unable to resolve ${domain}. Check if the DNS records are set up correctly."
    exit 1
  else
    echo "Resolved ${domain} to IP(s): ${resolved_ip}"
  fi
}

function test_s3_endpoint() {
  local domain=$1
  local expected_endpoint=$2

  echo "Testing if ${domain} points to the S3 website endpoint..."
  
  resolved_cname=$(dig +short ${domain} CNAME)
  
  if [[ "${resolved_cname}" == "${expected_endpoint}" ]]; then
    echo "SUCCESS: ${domain} correctly points to ${expected_endpoint}"
  else
    echo "ERROR: ${domain} does not point to the expected S3 endpoint (${expected_endpoint})."
    echo "Resolved CNAME: ${resolved_cname}"
    exit 1
  fi
}

test_dns_resolution "${DOMAIN_NAME}"
test_dns_resolution "${WWW_SUBDOMAIN}"
test_s3_endpoint "${DOMAIN_NAME}" "${EXPECTED_ENDPOINT}"
test_s3_endpoint "${WWW_SUBDOMAIN}" "${EXPECTED_ENDPOINT}"

echo "All tests passed. Route 53 configuration appears to be working correctly."
