#!/bin/sh

# be sure branch is up to date
git fetch origin

# in the last hundred commits, is one of the parents in the current master?
if ! (git log --pretty=format:'%H' -n 100 | grep -q "$(git rev-parse remotes/origin/master)"); then
  echo >&2 'Your branch is not up to date. Exiting.'
  exit 1
fi
