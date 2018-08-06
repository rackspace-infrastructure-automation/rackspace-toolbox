# aws-terraform-internal

Directory and Issue tracker for Terraform Modules used for Project Phoenix.

Feature Enhancements, Bug Reports, and New Module requests for all Terraform modules should be filed in this repository.

## Module Readiness

Modules may be in various states of development.

| Stage | Description |
| --------------------- | ------------- |
| In Development | A new module is actively being worked on and is not ready for testing or use |
| Needs Testing | Initial module development is complete, but the module does not have CI tests and is not certified for customer use |
| Ready | Module is tested and ready for customer use. |


## Module List

Please reference the below list of statuses prior to using any linked modules on customer builds.

| Module Name  | Developed | Unit/Self-Contained Testing | Integration Testing | Ready for Customer Use | Notes |
| --------------------- | ------------- |-|-|-|-|
| [ALB](https://github.com/rackspace-infrastructure-automation/aws-terraform-alb) | :white_check_mark: | :x: | :x: | :x:  | n/a |
| [Aurora](https://github.com/rackspace-infrastructure-automation/aws-terraform-aurora) | :white_check_mark: |  :x: | :x: | :x:  | n/a |
| [Cloudfront w/ Custom Origin](https://github.com/rackspace-infrastructure-automation/aws-terraform-cloudfront_custom_origin) | :white_check_mark: |  :white_check_mark: | :x: | :x:  | n/a |
| [Cloudfront w/ S3 Origin](https://github.com/rackspace-infrastructure-automation/aws-terraform-cloudfront_s3_origin) | :white_check_mark: |  :x: | :x: | :x:  | n/a |
| [EC2 ASG](https://github.com/rackspace-infrastructure-automation/aws-terraform-ec2_asg) | :white_check_mark: | :x: | :x: | :x:  | n/a |
| [EC2 Autorecovery](https://github.com/rackspace-infrastructure-automation/aws-terraform-ec2_autorecovery) | :white_check_mark: | :x: | :x: | :x:  | n/a |
| [ECS Cluster](https://github.com/rackspace-infrastructure-automation/aws-terraform-ecs_cluster) | :white_check_mark: | :x: | :x: | :x:  | n/a |
| [RDS](https://github.com/rackspace-infrastructure-automation/aws-terraform-rds) | :white_check_mark: | :x: | :x: | :x:  | n/a |
| [RMS](https://github.com/rackspace-infrastructure-automation/aws-terraform-rms) | :white_check_mark: | :x: | :x: | :x:  | n/a |
| [Route 53 Internal Zone](https://github.com/rackspace-infrastructure-automation/aws-terraform-route53_internal_zone) | :white_check_mark: | :x: | :white_check_mark: | :x:  | n/a |
| [S3](https://github.com/rackspace-infrastructure-automation/aws-terraform-s3) | :white_check_mark: | :x: | :white_check_mark: | :x: | n/a |
| [SNS](https://github.com/rackspace-infrastructure-automation/aws-terraform-sns) | :x: | :x: | :x: | :x: | n/a |
| [VPC Base Network](https://github.com/rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | n/a |
