variable "aws_region" {
  description = "The AWS region where the S3 bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

output "route53_name_servers" {
  description = "The Route 53 name servers to configure in Namecheap"
  value       = module.route53_dns.name_servers
}

variable "domain_name" {
  description = "The name of domain"
  type        = string
}
