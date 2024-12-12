variable "domain_name" {
  description = "The domain name to set up DNS for"
  type        = string
}

variable "s3_bucket_website_endpoint" {
  description = "The S3 bucket website endpoint (e.g., bucket-name.s3-website-region.amazonaws.com)"
  type        = string
}

variable "s3_bucket_hosted_zone_id" {
  description = "The hosted zone ID for the S3 bucket website"
  type        = string
}
