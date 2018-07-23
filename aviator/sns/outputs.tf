output "topic_id" {
  description = "The id of the SNS topic."
  value       = "${aws_sns_topic.MySNSTopic.id}"
}

output "topic_arn" {
  value = "${aws_sns_topic.MySNSTopic.arn}"
}
