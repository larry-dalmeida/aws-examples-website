output "zone_id" {
  description = "The Route 53 Zone ID"
  value       = aws_route53_zone.main_zone.zone_id
}

output "name_servers" {
  description = "The name servers for the domain"
  value       = aws_route53_zone.main_zone.name_servers
}
