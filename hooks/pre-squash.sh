#!/usr/bin/env bash

# New command to rename a branch

set -- "$*"

if [[ $3 == "" ]]; then
    echo "This command require a number of commits to squash from the latest"
    exit 1
fi
git reset --soft HEAD~"$3" && git commit;
exit 1
