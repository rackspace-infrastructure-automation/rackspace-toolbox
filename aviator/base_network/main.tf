# VPC
module "base_network" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v1.26.0"

  azs                      = "${var.azs}"
  cidr                     = "${var.cidr}"
  name                     = "${format("%s-%s", var.environment, var.vpc_name)}"
  private_subnets          = "${var.private_subnets}"
  public_subnets           = "${var.public_subnets}"
  enable_nat_gateway       = "${var.nat_gateways}"
  enable_s3_endpoint       = "${var.s3_endpoint}"
  enable_dynamodb_endpoint = "${var.dynamodb_endpoint}"

  tags {
    Environment     = "${var.environment}"
    ServiceProvider = "Rackspace"
    Name            = "${format("%s-%s", var.environment, var.vpc_name)}"
  }
}
