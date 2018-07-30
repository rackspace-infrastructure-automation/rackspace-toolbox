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

resource "random_string" "sqs_rstring" {
  length  = 18
  upper   = false
  special = false
}

resource "aws_sqs_queue" "my_sqs" {
  name = "${random_string.sqs_rstring.result}-my-example-queue"
}

module "sns_sqs" {
  source     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-sns.git"
  topic_name = "${random_string.sqs_rstring.result}-my-example-topic"

  create_subscription_1 = true
  protocol_1            = "sqs"
  endpoint_1            = "${aws_sqs_queue.my_sqs.arn}"
}
