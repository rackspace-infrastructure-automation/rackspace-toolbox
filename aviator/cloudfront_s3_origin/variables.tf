# Environment and tagging.
variable "environment" {
  description = "Application environment for which this is being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test')"
  type        = "string"
  default     = "Development"
}

variable "tags" {
  description = "Custom tags to apply to all resources."
  type        = "map"
  default     = {}
}

# ###################################################

# Enable Logging
# If you enable logging the bucket must already exist. You will get an error if you try
# to use a dynamic bucket like "${aws_s3_bucket.cloudfront_log_s3bucket.bucket_domain_name}"
# You must use something like bucket = "MyExistingbucket"
variable "bucket_logging" {
  description = "Enable logging to an S3 Bucket. If this is set you must configure below."
  type        = "string"
  default     = false
}

# ###################################################

# Top-Level parameters
variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution. (OPTIONAL)"
  type        = "list"
  default     = []
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. (OPTIONAL)"
  type        = "list"
  default     = []
}

variable "comment" {
  description = "Any comments you want to include about the distribution. (OPTIONAL)"
  type        = "string"
  default     = ""
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  type        = "string"
  default     = ""
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  type        = "string"
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution. (OPTIONAL)"
  type        = "string"
  default     = false
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2."
  type        = "string"
  default     = "http2"
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100."
  type        = "string"
  default     = "PriceClass_All"
}

# Default Cache Behavior
variable "allowed_methods" {
  description = "HTTP methods that CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Allowed values are: [\"HEAD\", \"GET\"], [\"GET\", \"HEAD\", \"OPTIONS\"], or [\"DELETE\", \"GET\", \"HEAD\", \"OPTIONS\", \"PATCH\", \"POST\", \"PUT\"]."
  type        = "list"
  default     = ["HEAD", "GET"]
}

variable "cached_methods" {
  description = "HTTP methods for which CloudFront caches responses. Allowed values are: [\"HEAD\", \"GET\"] or [\"GET\", \"HEAD\", \"OPTIONS\"]."
  type        = "list"
  default     = ["HEAD", "GET"]
}

variable "compress" {
  description = "Indicates whether CloudFront automatically compresses certain files for this cache behavior. (OPTIONAL)"
  type        = "string"
  default     = false
}

variable "default_ttl" {
  description = "The default time in seconds that objects stay in CloudFront caches before CloudFront forwards another request to your custom origin to determine whether the object has been updated."
  type        = "string"
  default     = "3600"
}

variable "lambdas" {
  description = "A map of lambda functions and triggers. See https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_LambdaFunctionAssociation.html"
  type        = "list"
  default     = []
}

variable "max_ttl" {
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. (OPTIONAL)"
  type        = "string"
  default     = "86400"
}

variable "min_ttl" {
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. (OPTIONAL)"
  type        = "string"
  default     = "0"
}

variable "path_pattern" {
  description = "The pattern to which an ordered cache behavior applies."
  type        = "string"
}

variable "smooth_streaming" {
  description = "Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior. (OPTIONAL)"
  type        = "string"
  default     = false
}

variable "target_origin_id" {
  description = "The ID value of the origin to which you want CloudFront to route requests when a request matches the value of the PathPattern property."
  type        = "string"
}

variable "trusted_signers" {
  description = "he AWS accounts, if any, that you want to allow to create signed URLs for private content. (OPTIONAL)"
  type        = "list"
  default     = []
}

variable "viewer_protocol_policy" {
  description = "the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https."
  type        = "string"
}

variable "forward" {
  description = "pecifies whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted_names"
  type        = "string"
  default     = "all"
}

variable "whitelisted_names" {
  description = "If you have specified whitelist to forward, the whitelisted cookies that you want."
  type        = "list"
  default     = []
}

# Default Cache Behavior - Forwarded Values - Headers
variable "headers" {
  description = "Specifies the headers that you want Amazon CloudFront to forward to the origin for this cache behavior. (OPTIONAL)"
  type        = "list"
  default     = []
}

# Default Cache Behavior - Forwarded Values - Query String
variable "query_string" {
  description = "Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior."
  type        = "string"
  default     = false
}

# Default Cache Behavior - Forwarded Values - Query String Cache Keys
variable "query_string_cache_keys" {
  description = "When specified, along with a value of true for query_string, all query strings are forwarded, however only the query string keys listed in this argument are cached. When omitted with a value of true for query_string, all query string keys are cached. (OPTIONAL)"
  type        = "list"
  default     = []
}

# S3 Logging
variable "bucket" {
  description = "The Amazon S3 bucket address where access logs are stored"
  type        = "string"
  default     = ""
}

variable "include_cookies" {
  description = "Indicates whether CloudFront includes cookies in access logs."
  type        = "string"
  default     = false
}

variable "prefix" {
  description = "Indicates whether CloudFront includes cookies in access logs."
  type        = "string"
  default     = ""
}

variable "domain_name" {
  description = "The DNS domain name of either the S3 bucket, or web site of your custom origin."
  type        = "string"
  default     = ""
}

variable "custom_header" {
  description = "One or more sub-resources with name and value parameters that specify header data that will be sent to the origin"
  type        = "list"
  default     = []
}

variable "origin_id" {
  description = "An identifier for the origin. The value of Id must be unique within the distribution."
  type        = "string"
}

variable "origin_path" {
  description = "The path that CloudFront uses to request content from an S3 bucket or custom origin. The combination of the DomainName and OriginPath properties must resolve to a valid path. The value must start with a slash mark (/) and cannot end with a slash mark. (OPTIONAL)"
  type        = "string"
  default     = ""
}

# Origin - S3 Origin
variable "origin_access_identity" {
  description = "The CloudFront origin access identity to associate with the origin. You must specify the full origin ID"
  type        = "string"
  default     = ""
}

# Restrictions
variable "locations" {
  description = "The two-letter, uppercase country code for a country that you want to include in your blacklist or whitelist."
  type        = "list"
  default     = []
}

variable "restriction_type" {
  description = "The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist."
  type        = "string"
  default     = ""
}

# SSL: Certificate
variable "acm_certificate_arn" {
  description = "The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id. The ACM certificate must be in US-EAST-1."
  type        = "string"
  default     = ""
}

variable "cloudfront_default_certificate" {
  description = "if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm_certificate_arn, or iam_certificate_id."
  type        = "string"
  default     = ""
}

variable "iam_certificate_id" {
  description = "The IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain. Specify this, acm_certificate_arn, or cloudfront_default_certificate."
  type        = "string"
  default     = ""
}

variable "minimum_protocol_version" {
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. See https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#minimum_protocol_version"
  type        = "string"
  default     = "TLSv1.2_2018"
}

variable "ssl_support_method" {
  description = "Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. Required if you specify acm_certificate_arn or iam_certificate_id. NOTE: vip causes CloudFront to use a dedicated IP address and may incur extra charges."
  type        = "string"
  default     = "sni-only"
}

# WAF
variable "web_acl_id" {
  description = "The AWS WAF web ACL to associate with this distribution."
  type        = "string"
  default     = ""
}
