#!/usr/bin/env bash

# New command to rename a branch

set -- "$*"
parameters=($1)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"$DIR"/..//lib/rename-branch.sh "${parameters[2]}" "${parameters[3]}"
exit 1
