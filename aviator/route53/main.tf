# Internal Hosted Zone

resource "aws_route53_zone" "internal_zone" {
  name = "${var.zone_name}"
  comment = "Hosted zone for ${contains(var.env_list, var.zone_environment) ? var.zone_environment:"Development"}"
  vpc_id = "${replace(var.target_vpc_id, "/^vpc-/", "") != var.target_vpc_id ? var.target_vpc_id:""}"
  tags {
    ServiceProvider = "Rackspace"
  }
}