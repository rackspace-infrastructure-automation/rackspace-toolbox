#!/usr/bin/env sh
set -eu

ID_FILE=$(ssh -G git@github.com | grep identityfile | cut -d' ' -f2 | xargs -I % sh -c 'test -r % && echo % || true' | head)
# ID_FILE="$HOME/.ssh/test_rsa"

FINGERPRINT=$(ssh-keygen -E md5 -lf "$ID_FILE" | cut -f2 -d' ')
echo >&2 '>>> signing with this identity file: '"$ID_FILE"' '"$FINGERPRINT"

TIME=$(date +%s)
REPO='rackspace-infrastructure-automation-dev/1013108-aws-260827023028-Phoenix-Sandbox-Do-Not-Delete'
MESSAGE='{"awsAccountNumber":"260827023028","timestamp":"'"$TIME"'","repoName":"'"$REPO"'"}'
echo '>>> sending: '"$MESSAGE"

set -o pipefail
SIGNATURE=$(printf $MESSAGE | openssl dgst -sha256 -sign $ID_FILE | base64 | tr -d '\n')

TEMP_OUTPUT=$(mktemp)
RESP_CODE=$(curl -sS -XPOST -d "$MESSAGE" \
  -H 'Accept: text/x-shellscript' -H 'Content-Type: application/json' \
  -H 'Authorization: Signature keyId="'"$FINGERPRINT"'",algorithm="rsa-sha256",signature="'"$SIGNATURE"'"' \
  -w '%{http_code}' -o "$TEMP_OUTPUT" \
  'https://github.api.dev.manage.rackspace.com/v0/github/pull-aws-credentials')

if [ "$RESP_CODE" != '200' ]; then
  echo >&2 '>>> request returned error: '"$RESP_CODE"
  cat >&2 $TEMP_OUTPUT
  echo >&2
  exit 1
fi

OUTPUT=${BASH_ENV:-/dev/stdout}
echo >&2 '>>> writing response to: '"$OUTPUT"
cat "$TEMP_OUTPUT" >> "$OUTPUT"

# wget --post-data "$MESSAGE" --content-on-error -O- \
#   --header='Accept: text/x-shellscript' --header='Content-Type: application/json' \
#   --header='Authorization: Signature keyId="'"$FINGERPRINT"'",algorithm="rsa-sha256",signature="'"$SIGNATURE"'"' \
#   'https://github.api.dev.manage.rackspace.com/v0/github/pull-aws-credentials' >> "$OUTPUT"
