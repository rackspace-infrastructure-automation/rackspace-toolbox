# List of availability zones to use for the environment, e.g. ["us-east-1a", "us-east-1b"]
variable "azs" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b"]
}

# CIDR block to use for the environment, e.g. "172.18.0.0/16"
variable "cidr" {
  default = "172.18.0.0/16"
}

# If no, nat gateways will not be deployed so private subnets have no outbound communication.
variable "nat_gateways" {
  default = true
}

# Should be true if you want to provision a DynamoDB endpoint to the VPC
variable "dynamodb_endpoint" {
  default = true
}

# Should be true if you want to provision an S3 endpoint to the VPC
variable "s3_endpoint" {
  default = true
}

# Name of the environment for the deployment.
variable "environment" {
  default = "Production"
}

# Name of the VPC.
variable "vpc_name" {
  default = "BaseNetwork"
}

# List of private subnets to create in the environment, e.g. ["172.18.0.0/21", "172.18.8.0/21"]
variable "private_subnets" {
  type    = "list"
  default = ["172.18.0.0/21", "172.18.8.0/21"]
}

# List of public subnets to create in the environment, e.g. ["172.18.168.0/22", "172.18.172.0/22"]
variable "public_subnets" {
  type    = "list"
  default = ["172.18.168.0/22", "172.18.172.0/22"]
}
