
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket_acl | Bucket ACL. Must be either authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control, log-delivery-write, private, public-read or public-read-write. For more details https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl | string | `bucket-owner-full-control` | no |
| bucket_logging | Enable bucket logging. Will store logs in another existing bucket. You must give the log-delivery group WRITE and READ_ACP permissions to the target bucket. i.e. true | false | string | `false` | no |
| bucket_name | The name of the S3 bucket for the access logs. The bucket name can contain only lowercase letters, numbers, periods (.), and dashes (-). Must be globally unique. If changed, forces a new resource. | string | - | yes |
| bucket_tags | A map of tags to be applied to the Bucket. i.e {Environment='Development'} | map | `<map>` | no |
| environment | Application environment for which this network is being created. must be one of ['Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test'] | string | `Development` | no |
| kms_master_key_id | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. | string | `` | no |
| lifecycle_enabled | Enable object lifecycle management. i.e. true | false | string | `false` | no |
| lifecycle_rule_prefix | Object keyname prefix identifying one or more objects to which the rule applies. Set as an empty string to target the whole bucket. | string | `` | no |
| logging_bucket_name | Name of the existing bucket where the logs will be stored. | string | `` | no |
| logging_bucket_prefix | Prefix for all log object keys. i.e. logs/ | string | `` | no |
| noncurrent_version_expiration_days | Indicates after how many days we are deleting previous version of objects.  Set to 0 to disable or at least 365 days longer than noncurrent_version_transition_glacier_days. i.e. 0 to disable, 1-999 otherwise | string | `0` | no |
| noncurrent_version_transition_glacier_days | Indicates after how many days we are moving previous versions to Glacier.  Should be 0 to disable or at least 30 days longer than noncurrent_version_transition_ia_days. i.e. 0 to disable, 1-999 otherwise | string | `0` | no |
| noncurrent_version_transition_ia_days | Indicates after how many days we are moving previous version objects to Standard-IA storage. Set to 0 to disable. | string | `0` | no |
| object_expiration_days | Indicates after how many days we are deleting current version of objects. Set to 0 to disable or at least 365 days longer than TransitionInDaysGlacier. i.e. 0 to disable, otherwise 1-999 | string | `0` | no |
| sse_algorithm | The server-side encryption algorithm to use. Valid values are AES256 and aws:kms | string | `AES256` | no |
| transition_to_glacier_days | Indicates after how many days we are moving current versions to Glacier.  Should be 0 to disable or at least 30 days longer than transition_to_ia_days. i.e. 0 to disable, otherwise 1-999 | string | `0` | no |
| transition_to_ia_days | Indicates after how many days we are moving current objects to Standard-IA storage. i.e. 0 to disable, otherwise 1-999 | string | `0` | no |
| versioning | Enable bucket versioning. i.e. true | false | string | `false` | no |
| website | Use bucket as a static website. i.e. true | false | string | `false` | no |
| website_error | Location of Error HTML file. i.e. error.html | string | `error.html` | no |
| website_index | Location of Index HTML file. i.e index.html | string | `index.html` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_arn | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| bucket_domain_name | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| bucket_hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region. |
| bucket_id | The name of the bucket. |
| bucket_region | The AWS region this bucket resides in. |

