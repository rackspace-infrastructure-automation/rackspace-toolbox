# Terraform Module Standards

## Introduction

To keep all modules consistent we have designed the following set of standards that should be adhered to in each module. Initial repositories in Github should be setup by [reaper](https://github.com/rackerlabs/reaper).

## Directory structure

`reaper` will setup the .circleci directory and contents, and the `README.md` all other files should be created manually. Final directory structure should look like the following.

```text
|-- .circle.ci
|   |-- bin
|   |   |-- apply.sh
|   |   |-- check_master.sh
|   |   |-- destroy.sh
|   |   |-- lint.sh
|   |   |-- plan.sh
|   |   |-- validate.sh
|   |-- config.yml
|-- examples
|   |-- named_example.tf
|   |-- named_example.tf
|-- tests
|   |-- test1
|   |   |-- main.tf
|   |-- test2
|   |   |-- main.tf
|-- .gitignore
|-- README.md
|-- main.tf
|-- outputs.tf
|-- variables.tf
```

The files in `example` can be named anything as long as they have `.tf` as the extension.

The `tests` directory must be called `tests` and each test must be `test#`. Inside each `test#` folder should be exactly one file called `main.tf`

`README.md` should be populated with the module documentation.

`main.tf`, `outputs.tf` and `variables.tf` is where the module should be built.

## variables.tf

This file must include the following code block at the beginning or end of the file.

```terraform
variable "environment" {
  description = "Application environment for which this network is being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test')"
  type        = "string"
  default     = "Development"
}

variable "tags" {
  description = "Custom tags to apply to all resources."
  type        = "map"
  default     = {}
}
```

## main.tf

This file must include the following code block at the top of the file. Other variables can be added to this block.

```terraform
locals {
  tags {
    Name            = "${var.name}"
    ServiceProvider = "Rackspace"
    Environment     = "${var.environment}"
  }
}
```

In any resource block that supports `tags` the following code should be used:

`tags = "${merge(var.tags, local.tags)}"`

This takes the tag values that are in `variable.tf` and combines them with any values defined in `main.tf` in the `locals` block.

## README.md

One way to document modules is to use [Terraform-docs](https://github.com/segmentio/terraform-docs) but this project seems to have been abandoned. Your mileage may vary.