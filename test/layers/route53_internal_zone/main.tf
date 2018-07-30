provider "random" {
  version = "~> 1.0"
}

provider "template" {
  version = "~> 1.0"
}

provider "aws" {
  version = "~> 1.2"
  region  = "us-east-1"
}

resource "random_string" "vpc_name" {
  length  = 8
  special = false
}

resource "random_string" "zone_name" {
  length  = 8
  special = false
}

module "r53_default_vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork.git"

  # all defaults
  vpc_name = "r53_default_vpc-${random_string.vpc_name.result}"
}

module "r53_default_zone" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53_internal_zone.git"

  # all defaults
  zone_name     = "zone-${random_string.vpc_name.result}"
  target_vpc_id = "${module.r53_default_vpc.vpc_id}"
}
