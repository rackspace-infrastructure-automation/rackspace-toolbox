# Internal Hosted Zone

locals {
  env_list = ["Development", "Integration", "PreProduction", "Production", "QA", "Staging", "Test"]
}

resource "aws_route53_zone" "internal_zone" {
  name = "${var.zone_name}"

  # Check given environment is in the accepted list, case-sensitive. True=use env, False=use 'Development'
  comment = "Hosted zone for ${contains(local.env_list, var.environment) ? var.environment:"Development"}"

  # Check to see if input starts with 'vpc-'. True=use input, False=use empty string
  vpc_id = "${replace(var.target_vpc_id, "/^vpc-/", "") != var.target_vpc_id ? var.target_vpc_id:""}"

  tags {
    ServiceProvider = "Rackspace"
  }
}
