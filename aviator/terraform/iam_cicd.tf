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

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.state_bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "NotPrincipal": { "AWS" : ["${aws_iam_user.circleci.arn}"] },
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.state_bucket_name}",
        "arn:aws:s3:::${var.state_bucket_name}/*"
      ]
    }
  ]
}
POLICY
}
