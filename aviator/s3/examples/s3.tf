module "s3" {
  source = "path/to/module"

  bucket_name = "<bucket_name>"

  bucket_acl = "bucket-owner-full-control"

  bucket_logging = false

  bucket_tags = {
    RightSaid = "Fred"
    LeftSaid  = "George"
  }

  environment = "Development"

  lifecycle_enabled = true

  noncurrent_version_expiration_days = "425"

  noncurrent_version_transition_glacier_days = "60"

  noncurrent_version_transition_ia_days = "30"

  object_expiration_days = "425"

  transition_to_glacier_days = "60"

  transition_to_ia_days = "30"

  versioning = true

  website = true

  website_error = "error.html"

  website_index = "index.html"
}
