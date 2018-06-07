# Route53 Internal Zone Creation

## Variables
```
variable "zone_name" {
  description = "TLD for Internal Hosted Zone, i.e. example.com"
  type = "string"
}

variable "zone_environment" {
  description = "Application environment for which this network is being created. e.g. Development/Production."
  type = "string"
  default = "Development"
  allowedValues = ["Development", "Integration", "PreProduction", "Production", "QA", "Staging", "Test"]
}

variable "target_vpc_id" {
  description = "Select Virtual Private Cloud ID, e.g. vpc-*"
  type = "string"
}

```


## Outputs

`internal_hosted_name` e.g. `internal_hosted_name = example.com`

`internal_hosted_zone_id` e.g. `internal_hosted_zone_id = Z2GW3D8EFNF0VC`