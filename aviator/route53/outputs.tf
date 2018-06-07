output "internal_hosted_name" {
  value = "${aws_route53_zone.internal_zone.name}"
}

output "internal_hosted_zone_id" {
  value = "${aws_route53_zone.internal_zone.id}"
}
