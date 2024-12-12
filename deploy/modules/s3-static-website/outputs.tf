output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.static_website.id
}

output "website_url" {
  description = "The S3 bucket website endpoint"
  value       = aws_s3_bucket_website_configuration.static_website.website_endpoint
}

output "hosted_zone_id" {
  value = aws_s3_bucket.static_website.hosted_zone_id
}