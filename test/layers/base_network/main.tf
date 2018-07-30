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

module "base_network_all_defaults" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork.git"

  # all defaults
  vpc_name = "all_defaults"
}

module "base_network_override_azs" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork.git"

  vpc_name            = "override_azs"
  cidr_range          = "10.0.0.0/16"
  custom_azs          = ["us-east-1a", "us-east-1b"]
  public_cidr_ranges  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_cidr_ranges = ["10.0.2.0/24", "10.0.4.0/24"]
}
