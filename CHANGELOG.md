# rackspace-toolbox Changelog

## [1.6.3](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.6.3) (Jan 11, 2019)

Uses bash `pipefail` option in all scripts.

## [1.6.2](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.6.2) ( Dec 21, 2018)

Adds this CHANGELOG.

## [1.6.1](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.6.1) ( Dec 18, 2018)

Fully rolls back code to match version 1.4.4. There was an issue detecting whether the current branch was in sync with master.

## [1.6.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.6.0) ( Dec 18, 2018)

Partially reverts changes introduced at 1.5.1.

## [1.5.1](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.5.1) ( Dec 17, 2018)

Fix issue where plan.sh incorrectly exited with 0  when `terraform plan` failed.

Code change at [#31](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/pull/31)

## [1.5.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.5.0) ( Dec 17, 2018)

Publishes artifacts to `/tmp/artifacts`.

Code change at [#30](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/pull/30)

## [1.4.4](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.4.4) ( Dec 3, 2018)

Allow empty layers to plan.

## [1.4.3](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.4.3) ( Nov 28, 2018)

Re-enable tuvok.

## [1.4.2](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.4.2) ( Nov 28, 2018)

Output full terraform init/plan/apply commands to aid in troubleshooting the full terraform commands that are executed will be shown in build output.

## [1.4.1](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.4.1) ( Nov 15, 2018)

Correctly reads `tf-applied-revision.sha` now. A bug was introduced recently that would cause reading tf-applied-revision.sha to fail, and then apply.sh would fallback to applying all layers. This release fixes it.

Code change at [#25](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/pull/25)

## [1.4.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.4.0) ( Nov 13, 2018)

Automatically fetches AWS credentials. Adds support for TF_STATE_BUCKET_V2.

Major changes at [#18](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/pull/18) and [#24](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/pull/24).

## [1.3.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.3.0) ( Nov 8, 2018)

Disable tuvok for the time being.

## [1.2.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.2.0) ( Nov 7, 2018)

Install missing versions of terraform.

## [1.1.1](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.1.1) ( Oct 31, 2018)

Ensure tuvok runs after installing it.

## [1.1.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.1.0) ( Oct 31, 2018)

Adds tuvok output to linting build step.

## [1.0.5](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.0.5) ( Oct 24, 2018)

Only looks for TF_STATE_BUCKET and TF_STATE_REGION when there's a layers directory.

## [1.0.4](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.0.4) ( Oct 23, 2018)

Includes terraform 0.11.9.

## [1.0.3](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.0.3) ( Oct 23, 2018)

Test improvements.

## [1.0.2](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.0.2) ( Oct 9, 2018)

Corrects check for existence of S3 `tf-applied-revision.sha` file.

## [1.0.1](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.0.1) ( Oct 8, 2018)

Fixed issue with extra image tags. Adds tests using BATS.

## [1.0.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/1.0.0) ( Oct 5, 2018)

Publish extra tags/versions.

## [0.2.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/0.2.0) ( Oct 2, 2018)

Removes need for call to `check_old.sh`. The verification for out-of-sync branches was not removed. It's done transparently as part of the other scripts.

## [0.1.1](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/0.1.1) ( Sep 25, 2018)

Fail scripts if AWS creds are missing.

## [0.1.0](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/0.1.0) ( Sep 25, 2018)

Pushes applied terraform revision to S3. A file named `tf-applied-revision.sha` will be pushed to the same S3 bucket used for TF state files. This file will then be used to compare with the revision being built and resolve which layers where modified since then.

## [0.0.1](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases/tag/0.0.1) ( Sep 12, 2018)

First tagged release.
