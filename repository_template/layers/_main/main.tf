# pinned provider versions

provider "random" {
  version = "~> 1.0"
}

provider "template" {
  version = "~> 1.0"
}

# default provider
provider "aws" {
  version             = "~> 1.2"
  allowed_account_ids = ["123456789012"]
}

# remote state
terraform {
  required_version = "0.11.7"

  backend "s3" {
    bucket  = "customer-environment-tfstate"
    key     = "terraform._main.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

# enabling circleci to run terraform
module "terraform_circleci_iam" {
  source = "git@github.com:rackspace-infrastructure-automation/customer-shared-git-url//modules/terraform?ref=v0.0.1"
}

# additional modules, for example, for a specific region (optional)
#
# provider "aws" {
#   version             = "~> 1.2"
#   allowed_account_ids = ["241176755253"]
#   region              = "us-east-1"
#
#   alias = "us-east-1"
# }
#
# module "us-east-1" {
#   source = "./us-east-1"
#
#   providers = {
#     aws = "aws.us-east-1"
#   }
# }

