resource "random_id" "alb_log_bucket_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "alb_log_bucket" {
  bucket        = "${format("%s-%s-alb-logs-%s", lower(var.environment), lower(var.alb_tier), random_id.alb_log_bucket_id.hex)}"
  force_destroy = "${var.force_destroy_log_bucket}"
  acl           = "bucket-owner-full-control"
  policy        = "${data.aws_iam_policy_document.bucket_policy.json}"

  lifecycle_rule {
    id      = "logretention"
    enabled = true

    expiration {
      days = "${var.alb_log_retention_days}"
    }
  }

  tags {
    Environment     = "${var.environment}"
    ServiceProvider = "Rackspace"
    Name            = "${format("%s-%s-alb-logs-%s", lower(var.environment), lower(var.alb_tier), random_id.alb_log_bucket_id.hex)}"
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "ELBAccessLogs20130930"
    actions   = ["s3:PutObject"]
    resources = ["${format("arn:aws:s3:::%s-%s-alb-logs-%s/*", lower(var.environment), lower(var.alb_tier), random_id.alb_log_bucket_id.hex)}"]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.alb_logs_account_ids, var.region)}:root"]
    }
  }
}

module "app_alb" {
  source = "github.com/terraform-aws-modules/terraform-aws-alb.git?ref=v3.1.0"

  # Naming will not match desired due to name_prefix enforcement in module
  load_balancer_name = "${format("%s-%s-ALB", var.environment, var.alb_tier)}"
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  vpc_id             = "${var.vpc_id}"
  subnets            = "${var.public_subnets}"

  log_bucket_name = "${aws_s3_bucket.alb_log_bucket.id}"

  tags {
    Environment     = "${var.environment}"
    ServiceProvider = "Rackspace"
    Name            = "${format("%s-%s-ALB", var.environment, var.alb_tier)}"
  }

  https_listeners          = "${local.https_listeners}"
  https_listeners_count    = "${length(local.https_listeners)}"
  http_tcp_listeners       = "${local.http_tcp_listeners}"
  http_tcp_listeners_count = "${length(local.http_tcp_listeners)}"
  target_groups            = "${local.target_groups}"
  target_groups_count      = "${length(local.target_groups)}"
}

resource "aws_route53_record" "app_alb_internal_dns" {
  zone_id = "${var.internal_zone_id}"
  name    = "${format("%s.alb.%s", lower(var.alb_tier), lower(var.environment))}"
  type    = "A"

  alias {
    name                   = "${module.app_alb.dns_name}"
    zone_id                = "${module.app_alb.load_balancer_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_cloudwatch_metric_alarm" "unhealthyhostcountalarm" {
  alarm_name = "${format("UnHealthyHostCountAlarm-%s-%s-ALB-%d", var.environment, var.alb_tier, count.index)}"

  count = "${var.alarms_enabled ? 1 : 0}"

  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "10"
  metric_name               = "UnHealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "Unhealthy Host count is above threshold, creating ticket."
  insufficient_data_actions = []
  unit                      = "Count"
  ok_actions                = ["${var.alarm_list}"]
  alarm_actions             = ["${var.alarm_list}"]

  dimensions {
    LoadBalancer = "${module.app_alb.load_balancer_arn_suffix}"

    # Regex removes the portions of the ARN leading up to the target group full name
    TargetGroup = "${replace(element(module.app_alb.target_group_arns, count.index), "/^.+?([^:]+)$/", "$1")}"
  }

  count = "${length(local.target_groups)}"
}
