output "secret_key" {
  value = "${aws_iam_access_key.circleci_key.secret}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.circleci_key.id}"
}

output "circleci_user_arn" {
  value = "${aws_iam_user.circleci.arn}"
}
