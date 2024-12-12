provider "aws" {
  region = var.aws_region
}

module "s3_static_website" {
  source          = "./modules/s3-static-website"
  bucket_name     = var.bucket_name
  index_file_path = "../${path.root}/app/index.html"
}

module "route53_dns" {
  source                     = "./modules/route53-dns"
  domain_name                = var.domain_name
  s3_bucket_website_endpoint = module.s3_static_website.website_url
  s3_bucket_hosted_zone_id   = module.s3_static_website.hosted_zone_id
}
