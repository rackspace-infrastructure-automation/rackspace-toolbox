variable "zone_name" {
  description = "TLD for Internal Hosted Zone. ( example.com )"
  type = "string"
}

variable "zone_environment" {
  description = "Application environment for which this network is being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test')"
  type = "string"
  default = "Development"
}

variable "env_list" {
  description = "Allowed values in Zone Environment."
  type = "list"
  default = ["Development", "Integration", "PreProduction", "Production", "QA", "Staging", "Test"]
}

variable "target_vpc_id" {
  description = "Select Virtual Private Cloud ID. ( vpc-* )"
  type = "string"
}

