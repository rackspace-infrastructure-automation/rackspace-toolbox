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

# aliased us-east-1 provider
provider "aws" {
  version             = "~> 1.2"
  allowed_account_ids = ["123456789012"]
  region              = "us-east-1"

  alias = "us-east-1"
}

# remote state
terraform {
  required_version = "0.11.4"

  backend "s3" {
    bucket  = "customer-environment-tfstate"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

# enabling circleci to run terraform
module "terraform_circleci_iam" {
  source = "git@github.com:rackspace-infrastructure-automation/customer-shared-git-url//terraform?ref=v0.0.1"
}

# regional modules

module "us-east-1" {
  source = "./us-east-1"

  providers = {
    aws = "aws.us-east-1"
  }
}
