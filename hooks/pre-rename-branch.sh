#!/usr/bin/env bash

# New command to rename a branch

set -- "$*"


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"$DIR"/..//lib/rename-branch.sh "$3" "$4"
exit 1
