#!/bin/sh

# avoid overridden ssh config for github.com
if ! (ssh -G rackspace.github.com | grep -q '^hostname github.com$'); then
  printf 'Host rackspace.github.com\n HostName github.com\n IdentityFile ~/.ssh/id_rsa' >> ~/.ssh/config
fi

# be sure branch is up to date
git fetch --depth 100 $(git config --get remote.origin.url | sed 's/git@github.com/git@rackspace.github.com/')

# in the last hundred commits, is one of the parents in the current master?
if ! (git log --pretty=format:'%H' -n 100 | grep -q "$(git rev-parse remotes/origin/master)"); then
  echo >&2 'Your branch is not up to date. Exiting.'
  exit 1
fi
