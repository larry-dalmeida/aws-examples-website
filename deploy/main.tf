provider "aws" {
  region = var.aws_region
}

module "s3_static_website" {
  source          = "./modules/s3-static-website"
  bucket_name     = var.bucket_name
  index_file_path = "../${path.root}/app/index.html"
}
