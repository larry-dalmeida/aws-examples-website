output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3_static_website.bucket_name
}

output "s3_website_url" {
  description = "The S3 bucket website endpoint"
  value       = module.s3_static_website.website_url
}
