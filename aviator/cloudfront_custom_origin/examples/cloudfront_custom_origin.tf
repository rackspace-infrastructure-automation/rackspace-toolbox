provider "aws" {
  region = "us-west-2"
}

resource "random_string" "cloudfront_rstring" {
  length  = 18
  upper   = false
  special = false
}

module "cloudfront_custom_origin" {
  source              = "/path/to/module"
  domain_name         = "customdomain.testing.example.com"
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

  # Custom Origin
  https_port             = 443
  origin_protocol_policy = "https-only"

  aliases = ["testdomain.testing.example.com"]

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
