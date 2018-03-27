resource "random_string" "AlertLogicExternalId" {
  length  = 25
  special = false
}

resource "aws_cloudformation_stack" "rms_stack" {
  name = "rms-stack"

  parameters {
    Subnets                       = "${join(",", var.Subnets)}"
    VPCID                         = "${var.VPCID}"
    CloudTrailLogBucket           = "${var.CloudTrailLogBucket}"
    AvailabilityZoneCount         = "${var.AvailabilityZoneCount}"
    AlertLogicDataCenter          = "US"
    VPCCIDR                       = "${var.VPCCIDR}"
    ThreatManagerBuildState       = "Deploy"
    ThreatManagerVolumeSize       = "50"
    Environment                   = "${var.environment}"
    KeyName                       = "${var.KeyName}"
    AlertLogicExternalId          = "${random_string.AlertLogicExternalId.result}"
    InstanceRoleManagedPolicyArns = "${var.InstanceRoleManagedPolicyArns}"
    ThreatManagerInstanceType     = "${var.ThreatManagerInstanceType}"
    DisableApiTermination         = "${var.DisableApiTermination}"
  }

  template_body = "${file("${path.module}/rms.template")}"
  capabilities  = ["CAPABILITY_IAM"]
}
