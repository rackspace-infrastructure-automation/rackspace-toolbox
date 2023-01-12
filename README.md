# rackspace-toolbox.

This is a docker image published to GCR (gcr.io/rs-public-containers/rackspace-toolbox). It's part of Rackspace's [Managed Infrastructure as Code](https://manage.rackspace.com/aws/docs/product-guide/miac.html) offering.

[![CircleCI](https://circleci.com/gh/rackspace-infrastructure-automation/rackspace-toolbox.svg?style=svg&circle-token=f589f8bc84999fb48fe819fa553e50e7594654d0)](https://circleci.com/gh/rackspace-infrastructure-automation/rackspace-toolbox)

Image tags:
- GitHub [releases](https://github.com/rackspace-infrastructure-automation/rackspace-toolbox/releases)
- `master` has the latest stable version
- `branch_{branch_name}` and git sha for newly created branches (useful for trying out code from toolbox changes in development)

# Running tests locally.

All but the smoke test should pass locally by running `./scripts/test-local`.

In order to have the smoke test pass locally, you'll need credentials to the _Janus Playground_ account. You can configure an extra profile using `aws configure --profile janus-playground`. See https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html for more information. After doing that, run:

```
AWS_PROFILE=janus-playground ./scripts/test-local
```
