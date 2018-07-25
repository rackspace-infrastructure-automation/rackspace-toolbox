# aws-terraform-internal

Directory and Issue tracker for Terraform Modules used for Project Phoenix. Each module listed is actually a link to the standalone repository for that module. Development and testing should be done against the linked repo. DO NOT clone this repo for module development purposes.

Feature Enhancements, Bug Reports, and New Module requests for all Terraform modules should be filed in this repository.

## Module Readiness

Linked modules may be in various states of development.

| Stage			| Description	|
| ---------------------	| -------------	|
| In Development	| A new module is actively being worked on and is not ready for testing or use |
| Needs Testing		| Initial module development is complete, but the module does not have CI tests and is not certified for customer use |
| Ready			| Module is tested and ready for customer use. |

Please reference the below list of statuses prior to using any linked modules on customer builds.

| Module Name		| Status	|
| --------------------- | -------------	|
| [ALB](https://github.com/rackspace-infrastructure-automation/aws-terraform-alb)		| Needs Testing	|

