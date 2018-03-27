variable "vpc_id" {
  type = "string"
}

variable "environment" {
  default = "Production"
}

variable "alb_tier" {
  default = "Web"
}

variable "force_destroy_log_bucket" {
  default = true
}

variable "alb_log_retention_days" {
  default = 14
}

variable "acm_certificate_arn" {
  default = "arn:aws:acm:us-east-1:12345:certificate/0f1234"
}

variable "private_subnets" {
  type    = "list"
  default = ["172.18.0.0/21", "172.18.8.0/21"]
}

variable "public_subnets" {
  type    = "list"
  default = ["172.18.168.0/22", "172.18.172.0/22"]
}

variable "alarms_enabled" {
  default = false
}

variable "alarm_list" {
  type = "list"

  default = [
    "arn:aws:sns:us-east-1:1234567890:rackspace-support-emergency",
  ]
}

variable "alb_logs_account_ids" {
  type = "map"

  default = {
    "us-east-1"      = "127311923021"
    "us-east-2"      = "033677994240"
    "us-west-1"      = "027434742980"
    "us-west-2"      = "797873946194"
    "ca-central-1"   = "985666609251"
    "eu-central-1"   = "054676820928"
    "eu-west-1"      = "156460612806"
    "eu-west-2"      = "652711504416"
    "eu-west-3"      = "009996457667"
    "ap-northeast-1" = "582318560864"
    "ap-northeast-2" = "600734575887"
    "ap-northeast-3" = "383597477331"
    "ap-southeast-1" = "114774131450"
    "ap-southeast-2" = "783225319266"
    "ap-south-1"     = "718504428378"
    "sa-east-1"      = "507241528517"
  }
}

variable "region" {
  default = "us-east-1"
}

resource "aws_security_group" "alb_sg" {
  name        = "${format("%s-%s", var.environment, "ALB-SecurityGroup")}"
  description = "Allow Access to Internet Facing ALB"
  vpc_id      = "${var.vpc_id}"

  tags {
    Environment     = "${var.environment}"
    ServiceProvider = "Rackspace"
    Name            = "${format("%s-%s", var.environment, "ALB-SecurityGroup")}"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "internal_zone_id" {
  type = "string"
}
