#!/usr/bin/env bash

# New command to rename a branch

set -- "$*"
parameters=($1)

if [[ ${parameters[2]} == "" ]]; then
    echo "This command require a number of commits to squash from the latest"
    exit 1
fi
git reset --soft HEAD~"${parameters[2]}" && git commit;
exit 1
