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
  name = "my-example-queue-${random_string.sqs_rstring.result}"
}

module "sns_sqs" {
  source     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-sns.git"
  topic_name = "my-example-topic-${random_string.sqs_rstring.result}"

  create_subscription_1 = true
  protocol_1            = "sqs"
  endpoint_1            = "${aws_sqs_queue.my_sqs.arn}"
}
