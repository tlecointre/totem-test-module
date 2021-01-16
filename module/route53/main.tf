resource "aws_route53_record" "dns" {
  zone_id = var.route53_zone_id
  name    = var.route53_domain_name_api
  type    = var.type
  ttl     = var.ttl
  records = var.records
}