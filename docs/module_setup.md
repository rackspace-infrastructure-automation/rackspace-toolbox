# Terraform Module Setup

This document outlines the steps required to connect CircleCI to a terraform module repo, and to add the required code to the repo for CI testing and usage examples.

1. Copy the `.circleci` directory from [/module_templates/.circleci](../module_templates/.circleci).  This file should overwrite any existing .circleci configuration
2. Copy latest bin scripts from [/repository_template/bin](../repository_template/bin) to the `.circleci/bin` directory of repo
3. Create a `tests` directory with one subfolder per test required.  A sample can be found at [/module_templates/tests](../module_templates/tests).
    - When referencing the repo module in the tests. the source should be set to `"../../module"`.
4. Create an `examples` directory to contain all necessary examples of module use [/module_templates/tests](../module_templates/tests).
    - When referencing the repo module in the tests. the source should be set to `"git@github.com:rackspace-infrastructure-automation/<MODULE>//?ref=<VERSION>"`, with `<MODULE>` and `<VERSION>` replaced with the appropriate values.
5. Update execution permissions for all CI scripts
    - Linux - `chmod +x .circleci/bin/*.sh`
    - Windows - `git add .\.circleci\bin; gci .\.circleci\bin\*.sh | foreach {git update-index --chmod=+x $_.fullname}`
6. Connect CircleCI to the repo.
    - Load the CircleCI console for our github org -  https://circleci.com/add-projects/gh/rackspace-infrastructure-automation
    - Find the repo in the list, and if there is a `Set Up Project` button for this repo, click it to initiate the setup.  On the following screen, click the `Start Building` button.  No tests are defined in the repo, but this will ensure tests are run on feature branches.
    - If there is a `Follow Project` button listed for the repo, it is suggested to click this button.  This will ensure the repo is easily accessible from the CircleCI UI.
7. Update the CircleCI configuration to include the AWS credentials.
    - Load https://circleci.com/gh/rackspace-infrastructure-automation, locate the repo in the list of projects\repos and click the settings icon for the repo.  If the repo is not listed, return to the previous step, and click the `Follow Project` button for the repo.
    - Load the the `Environment Variable` configuration section, and add two environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.The values for these variables are stored at https://passwordsafe.corp.rackspace.com/projects/11457/credentials/191006/edit
8. Return to your workstation, commit all repo changes, and push to a feature branch.  CI tests should now be executing on each commit.
9. Verify if the GitHub repo is configured properly.  Settings to check include:
    - `Options - Features`: `Wikis`, `Issues`, and `Projects` should all be disabled.
    - `Branches - Protected Branches` - master branch should be listed under `Protected Branches`.
    - `Branches - Protected Branches - master` - `Protect this branch` should be enabled
    - `Branches - Protected Branches - master` - `Require pull request reviews before merging` should be enabled, with 2 PR reviews required.
    - `Branches - Protected Branches - master` - `Dismiss stale pull request approvals when new commits are pushed` should be enabled.
    - `Branches - Protected Branches - master` - `Require status checks to pass before merging`, `Requires branches to be up to date before merging` and the `ci/circleci: test` status check should all be enabled.
    - `Branches - Protected Branches - master` - `Include administrators` should be enabled.
