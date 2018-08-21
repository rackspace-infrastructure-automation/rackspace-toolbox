provider "aws" {
  version = "~> 1.2"
  region  = "us-west-2"
}

# Base Network setup with VPC Endpoints.
module "base_network" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.0.1"

  vpc_name   = "Rackspace-VPC"
  custom_azs = ["us-west-2a", "us-west-2b"]

  cidr_range          = "172.18.0.0/16"
  public_cidr_ranges  = ["172.18.168.0/22", "172.18.172.0/22"]
  private_cidr_ranges = ["172.18.0.0/21", "172.18.8.0/21"]
  environment         = "Production"
}

module "vpc_endpoint" {
  source                    = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_endpoint//?ref=v0.0.1"
  resource_name             = "Rackspace-VPC-Endpoint"
  vpc_id                    = "${module.base_network.vpc_id}"
  route_tables_ids_list     = "${module.base_network.private_route_tables}"
  dynamo_db_endpoint_enable = true
  s3_endpoint_enable        = true
}

# Creation of Security Groups.
module "security_groups" {
  source        = "git@github.com:rackspace-infrastructure-automation/aws-terraform-security_group//?ref=v0.0.2"
  resource_name = "security_groups"
  vpc_id        = "${module.base_network.vpc_id}"
  environment   = "Production"
}

# SNS Topic creation
module "sns_topic" {
  source      = "git@github.com:rackspace-infrastructure-automation/aws-terraform-sns//?ref=v0.0.1"
  topic_name  = "Rackspace-SNS-Topic"
}

# Service Role Creation
module "ssm_service_roles" {
  source                         = "git@github.com:rackspace-infrastructure-automation/aws-terraform-iam_resources//modules/ssm_service_roles?ref=v0.0.1"
  create_automation_role         = true
  create_maintenance_window_role = true
}