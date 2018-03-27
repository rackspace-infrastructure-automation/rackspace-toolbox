# Internal Hosted Zone
resource "aws_route53_zone" "internal_zone" {
  name    = "${lower(var.environment)}"
  vpc_id  = "${var.vpc_id}"
  comment = "Hosted zone for ${var.environment}"

  tags {
    ServiceProvider = "Rackspace"
  }
}
