#!/bin/bash

BUCKET_NAME="india-to-germany.de-cfa"
DOMAIN_NAME="indiatogermany.de"
WWW_SUBDOMAIN="www.${DOMAIN_NAME}"
EXPECTED_ENDPOINT="${BUCKET_NAME}.s3-website.eu-central-1.amazonaws.com"

function validate_dns_configuration() {
    ZONE_ID=$(aws route53 list-hosted-zones | jq -r '.HostedZones[] | select(.Name == "indiatogermany.de.") | .Id')
    if [[ -z "${ZONE_ID}" ]]; then
        echo "ERROR: Route 53 hosted zone for indiatogermany.de not found."
        exit 1
    fi

    RECORDS=$(aws route53 list-resource-record-sets --hosted-zone-id $ZONE_ID)

    # Check for A record
    echo "Checking A record for ${DOMAIN_NAME}..."
    A_RECORD=$(echo "$RECORDS" | jq -r --arg domain "${DOMAIN_NAME}." '.ResourceRecordSets[] | select(.Name == $domain and .Type == "A") | .AliasTarget.DNSName')

    if [[ "$A_RECORD" == "$EXPECTED_ENDPOINT." ]]; then
        echo "A record exists for ${DOMAIN_NAME} with target ${A_RECORD}."
    else
        echo "A record is missing or does not match. Found: ${A_RECORD}, Expected: ${EXPECTED_ENDPOINT}."
        exit 1
    fi

    # Check for CNAME record
    echo "Checking CNAME record for ${WWW_SUBDOMAIN}..."
    CNAME_RECORD=$(echo "$RECORDS" | jq -r --arg subdomain "${WWW_SUBDOMAIN}." '.ResourceRecordSets[] | select(.Name == $subdomain and .Type == "CNAME") | .ResourceRecords[0].Value')
    if [[ "$CNAME_RECORD" == "$EXPECTED_ENDPOINT" ]]; then
        echo "CNAME record exists for ${WWW_SUBDOMAIN} with target ${CNAME_RECORD}."
    else
        echo "CNAME record is missing or does not match. Found: ${CNAME_RECORD}, Expected: ${EXPECTED_ENDPOINT}."
        exit 1
    fi

    echo "All records are correctly configured."

    NAME_SERVERS=$(aws route53 get-hosted-zone --id /hostedzone/Z06900573PU307FFPA253 | jq '.DelegationSet.NameServers')
    echo $NAME_SERVERS | jq .
}

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

validate_dns_configuration
test_dns_resolution "${WWW_SUBDOMAIN}"
test_dns_resolution "${DOMAIN_NAME}"
test_s3_endpoint "${DOMAIN_NAME}" "${EXPECTED_ENDPOINT}"
test_s3_endpoint "${WWW_SUBDOMAIN}" "${EXPECTED_ENDPOINT}"

echo "All tests passed. Route 53 configuration appears to be working correctly."
