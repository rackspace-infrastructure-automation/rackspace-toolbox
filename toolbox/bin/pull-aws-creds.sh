#!/usr/bin/env sh
set -eu

API_BASE="${API_BASE:-https://github.api.manage.rackspace.com}"

KEY_FILE=${KEY_FILE:-"$HOME/.ssh/id_rsa"}

fail() {
  echo >&2 "This tool needs an SSH key to sign a request to $API_BASE."
  echo >&2 "The key must be configured as a deploy key in your GitHub repository linked to an AWS account."
  echo >&2 'The default path for the key is "$HOME/.ssh/id_rsa". You can override that by providing a KEY_FILE environment variable.'
  if [ "${CIRCLECI:-}" = "true" ]; then
    echo >&2 'It looks like this failure is happening inside CircleCI.'
    echo >&2 'CircleCI projects are expected to have a deploy key configured in its "Checkout SSH keys" section.'
  fi
  exit 1
}

if [ ! -r "$KEY_FILE" ]; then
  echo >&2 '> Key file not found: '"$KEY_FILE"
  fail
fi

set -o pipefail
FINGERPRINT=$(ssh-keygen -E md5 -lf "$KEY_FILE" | cut -f2 -d' ')
REPO_NAME=${REPO_NAME:-$(git config --get remote.origin.url | sed -e 's/^git@github[.]com://' -e 's/^[^\/]*\///' -e 's/[.]git$//')}
TIME=$(date +%s)
MESSAGE='{"awsAccountNumber":"'"$TF_VAR_aws_account_id"'","timestamp":"'"$TIME"'","repoName":"'"$REPO_NAME"'"}'

echo >&2 "> Requesting credentials for $TF_VAR_aws_account_id. Signing request with $KEY_FILE ($FINGERPRINT)."

SIGNATURE=$(printf $MESSAGE | openssl dgst -sha256 -sign $KEY_FILE | base64 | tr -d '\n')

TEMP_OUTPUT=$(mktemp)
RESP_CODE=$(curl --silent --show-error --request POST --data "$MESSAGE" \
  --header 'Accept: text/x-shellscript' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Signature keyId="'"$FINGERPRINT"'",algorithm="rsa-sha256",signature="'"$SIGNATURE"'"' \
  --write-out '%{http_code}' --output "$TEMP_OUTPUT" \
  --retry 2 --retry-connrefused \
  "${API_BASE}/v0/aws/credentials")

if [ "$RESP_CODE" != '200' ]; then
  echo >&2 '> Request returned error: '"$RESP_CODE"
  cat >&2 $TEMP_OUTPUT
  echo >&2
  fail
fi

OUTPUT=${BASH_ENV:-/dev/stdout}
echo >&2 '> Writing response to: '"$OUTPUT"
cat "$TEMP_OUTPUT" >> "$OUTPUT"
source "$TEMP_OUTPUT"
