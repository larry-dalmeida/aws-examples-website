resource "aws_route53_zone" "main_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "www_record" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  records = [var.s3_bucket_website_endpoint]
}

resource "aws_route53_record" "root_record" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.s3_bucket_website_endpoint
    zone_id                = var.s3_bucket_hosted_zone_id
    evaluate_target_health = false
  }
}
