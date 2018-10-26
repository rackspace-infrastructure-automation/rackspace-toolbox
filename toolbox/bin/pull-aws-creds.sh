#!/usr/bin/env sh
set -eu

ID_FILE=$(ssh -G git@github.com | grep identityfile | cut -d' ' -f2 | xargs -I % sh -c 'test -r % && echo % || true' | head)
# ID_FILE='/Users/jp/.ssh/test_rsa'

echo >&2 '>>> signing with this identity file:' $ID_FILE

# MESSAGE='{"user":"jpbochi"}'
# MESSAGE='{"repoName":"rackspace-infrastructure-automation/rackspace-toolbox"}'
MESSAGE='{"repoName":"rackspace-infrastructure-automation-dev/1013108-aws-260827023028-Phoenix-Sandbox-Do-Not-Delete"}'
echo >&2 '>>> sending:' $MESSAGE

set -o pipefail
SIGNATURE=$(printf $MESSAGE | openssl dgst -sha256 -sign $ID_FILE | base64 | tr -d '\n')

ESCAPED_MESSAGE=$(printf $MESSAGE | sed 's/"/\\"/g')
set -x
curl -i -XPOST -d "$MESSAGE" -H 'Content-Type: application/json' -H "x-phoenix-signature: $SIGNATURE" 'https://github.api.dev.manage.rackspace.com/v0/github'
