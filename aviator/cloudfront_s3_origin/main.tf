locals {
  tags = {
    Name            = "${var.origin_id}"
    ServiceProvider = "Rackspace"
    Environment     = "${var.environment}"
  }

  bucket_logging = {
    enabled = [{
      bucket          = "${var.bucket}"
      include_cookies = "${var.include_cookies}"
      prefix          = "${var.prefix}"
    }]

    disabled = "${list()}"
  }

  bucket_logging_config = "${var.bucket_logging ? "enabled" : "disabled"}"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  aliases = "${var.aliases}"

  default_cache_behavior {
    allowed_methods = "${var.allowed_methods}"
    cached_methods  = "${var.cached_methods}"
    compress        = "${var.compress}"
    default_ttl     = "${var.default_ttl}"

    forwarded_values {
      cookies {
        forward           = "${var.forward}"
        whitelisted_names = "${var.whitelisted_names}"
      }

      headers                 = "${var.headers}"
      query_string            = "${var.query_string}"
      query_string_cache_keys = "${var.query_string_cache_keys}"
    }

    lambda_function_association = "${var.lambdas}"

    max_ttl                = "${var.max_ttl}"
    min_ttl                = "${var.min_ttl}"
    smooth_streaming       = "${var.smooth_streaming}"
    target_origin_id       = "${var.target_origin_id}"
    trusted_signers        = "${var.trusted_signers}"
    viewer_protocol_policy = "${var.viewer_protocol_policy}"
  }

  comment             = "${var.comment}"
  default_root_object = "${var.default_root_object}"
  enabled             = "${var.enabled}"
  http_version        = "${var.http_version}"
  is_ipv6_enabled     = "${var.is_ipv6_enabled}"

  logging_config = ["${local.bucket_logging[local.bucket_logging_config]}"]

  origin {
    domain_name   = "${var.domain_name}"
    custom_header = "${var.custom_header}"
    origin_id     = "${var.origin_id}"
    origin_path   = "${var.origin_path}"

    s3_origin_config {
      origin_access_identity = "${var.origin_access_identity}"
    }
  }

  price_class = "${var.price_class}"

  restrictions {
    geo_restriction {
      locations        = "${var.locations}"
      restriction_type = "${var.restriction_type}"
    }
  }

  tags = "${merge(var.tags, local.tags)}"

  viewer_certificate {
    acm_certificate_arn            = "${var.acm_certificate_arn}"
    cloudfront_default_certificate = "${var.cloudfront_default_certificate}"
    iam_certificate_id             = "${var.iam_certificate_id}"
    minimum_protocol_version       = "${var.minimum_protocol_version}"
    ssl_support_method             = "${var.ssl_support_method}"
  }

  web_acl_id = "${var.web_acl_id}"
}
