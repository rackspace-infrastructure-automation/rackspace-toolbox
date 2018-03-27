variable "Subnets" {
  type = "list"
}

variable "VPCID" {
  type = "string"
}

variable "CloudTrailLogBucket" {
  type = "string"
}

variable "AvailabilityZoneCount" {
  type = "string"
}

variable "VPCCIDR" {
  type = "string"
}

variable "Environment" {
  type = "string"
}

variable "KeyName" {
  type = "string"
}

variable "InstanceRoleManagedPolicyArns" {
  type = "string"
}

variable "ThreatManagerInstanceType" {
  type = "string"
}

variable "DisableApiTermination" {
  type    = "string"
  default = "False"
}

variable "environment" {
  default = "Production"
}
