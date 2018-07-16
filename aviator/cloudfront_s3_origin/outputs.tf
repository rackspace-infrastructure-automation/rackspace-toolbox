output "id" {
  description = "The identifier for the distribution."
  value       = "${aws_cloudfront_distribution.cf_distribution.id}"
}

output "arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = "${aws_cloudfront_distribution.cf_distribution.arn}"
}

output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = "${aws_cloudfront_distribution.cf_distribution.caller_reference}"
}

output "status" {
  description = "The current status of the distribution."
  value       = "${aws_cloudfront_distribution.cf_distribution.status}"
}

output "active_trusted_signers" {
  description = "The key pair IDs that CloudFront is aware of for each trusted signer, if the distribution is set up to serve private content with signed URLs."
  value       = "${aws_cloudfront_distribution.cf_distribution.active_trusted_signers}"
}

output "domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = "${aws_cloudfront_distribution.cf_distribution.domain_name}"
}

output "last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = "${aws_cloudfront_distribution.cf_distribution.last_modified_time}"
}

output "in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = "${aws_cloudfront_distribution.cf_distribution.in_progress_validation_batches}"
}

output "etag" {
  description = "The current version of the distribution's information."
  value       = "${aws_cloudfront_distribution.cf_distribution.etag}"
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = "${aws_cloudfront_distribution.cf_distribution.hosted_zone_id}"
}
