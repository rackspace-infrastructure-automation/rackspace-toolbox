resource "aws_iam_access_key" "circleci_key" {
  user = "${aws_iam_user.circleci.name}"
}

resource "aws_iam_user" "circleci" {
  name = "circleci"
}

resource "aws_iam_user_policy_attachment" "circleci_policy" {
  user       = "${aws_iam_user.circleci.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
