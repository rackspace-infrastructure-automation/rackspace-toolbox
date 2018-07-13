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

module "base_network" "test1" {
  source = "../../../aviator/base_network"

  # all defaults
  vpc_name = "test"
}
