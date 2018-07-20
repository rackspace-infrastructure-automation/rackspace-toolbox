provider "aws" {
  region = "us-west-2"
}

resource "random_string" "cloudfront_rstring" {
  length  = 18
  upper   = false
  special = false
}

resource "aws_s3_bucket" "cloudfront_s3bucket" {
  bucket = "${random_string.cloudfront_rstring.result}-cf-distro-bucket"
  acl    = "public-read"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "origin accessid for cloudfront"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cloudfront_s3bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.cloudfront_s3bucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_s3bucket_policy" {
  bucket = "${aws_s3_bucket.cloudfront_s3bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

module "cloudfront_s3_origin" {
  source              = "/path/to/module"
  domain_name         = "${aws_s3_bucket.cloudfront_s3bucket.bucket_regional_domain_name}"
  origin_id           = "${random_string.cloudfront_rstring.result}"
  enabled             = true
  comment             = "This is a test comment"
  default_root_object = "index.html"

  # logging config 
  # Bucket must already exist, can't be generated as a resource along with example.
  # This is a TF bug.
  # The bucket name must be the full bucket ie bucket.s3.amazonaws.com
  bucket = "mybucket.s3.amazonaws.com"

  prefix         = "myprefix"
  bucket_logging = true

  aliases = ["testdomain.testing.example.com"]

  # Origin access id
  origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"

  # default cache behavior
  allowed_methods  = ["GET", "HEAD"]
  cached_methods   = ["GET", "HEAD"]
  path_pattern     = "*"
  target_origin_id = "${random_string.cloudfront_rstring.result}"

  # Forwarded Values
  query_string = false

  #Cookies
  forward = "none"

  viewer_protocol_policy = "redirect-to-https"
  default_ttl            = "3600"

  price_class = "PriceClass_200"

  # restrictions
  restriction_type = "whitelist"
  locations        = ["US", "CA", "GB", "DE"]

  # Certificate
  cloudfront_default_certificate = true
}
