#!/usr/bin/env sh
set -eu

API_BASE="${API_BASE:-https://github.api.manage.rackspace.com}"

ID_FILE=$(ssh -G git@github.com | grep identityfile | cut -d' ' -f2 | xargs -I % sh -c 'test -r % && echo % || true' | head)

FINGERPRINT=$(ssh-keygen -E md5 -lf "$ID_FILE" | cut -f2 -d' ')
echo >&2 '>>> Request to be signed with: '"$ID_FILE"' '"$FINGERPRINT"

REPO_NAME=${REPO_NAME:-$(git config --get remote.origin.url | sed -e 's/^git@github[.]com://' -e 's/^[^\/]*\///' -e 's/[.]git$//')}
TIME=$(date +%s)
MESSAGE='{"awsAccountNumber":"'"$TF_VAR_aws_account_id"'","timestamp":"'"$TIME"'","repoName":"'"$REPO_NAME"'"}'
echo '>>> Requesting credentials: '"$MESSAGE"

set -o pipefail
SIGNATURE=$(printf $MESSAGE | openssl dgst -sha256 -sign $ID_FILE | base64 | tr -d '\n')

TEMP_OUTPUT=$(mktemp)
RESP_CODE=$(curl -sS -XPOST -d "$MESSAGE" \
  -H 'Accept: text/x-shellscript' -H 'Content-Type: application/json' \
  -H 'Authorization: Signature keyId="'"$FINGERPRINT"'",algorithm="rsa-sha256",signature="'"$SIGNATURE"'"' \
  -w '%{http_code}' -o "$TEMP_OUTPUT" \
  "${API_BASE}/v0/aws/credentials")

if [ "$RESP_CODE" != '200' ]; then
  echo >&2 '>>> Request returned error: '"$RESP_CODE"
  cat >&2 $TEMP_OUTPUT
  echo >&2
  exit 1
fi

OUTPUT=${BASH_ENV:-/dev/stdout}
echo >&2 '>>> Writing response to: '"$OUTPUT"
cat "$TEMP_OUTPUT" >> "$OUTPUT"
