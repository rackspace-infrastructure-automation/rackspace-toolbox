resource "aws_sns_topic" "MySNSTopic" {
  name = "${var.topic_name}"
}

resource "aws_sns_topic_subscription" "Subscription1" {
  count     = "${var.create_subscription_1}"
  topic_arn = "${aws_sns_topic.MySNSTopic.arn}"
  protocol  = "${var.protocol_1}"
  endpoint  = "${var.endpoint_1}"
}

resource "aws_sns_topic_subscription" "Subscription2" {
  count     = "${var.create_subscription_2}"
  topic_arn = "${aws_sns_topic.MySNSTopic.arn}"
  protocol  = "${var.protocol_2}"
  endpoint  = "${var.endpoint_2}"
}

resource "aws_sns_topic_subscription" "Subscription3" {
  count     = "${var.create_subscription_3}"
  topic_arn = "${aws_sns_topic.MySNSTopic.arn}"
  protocol  = "${var.protocol_3}"
  endpoint  = "${var.endpoint_3}"
}
