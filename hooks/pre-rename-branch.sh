#!/usr/bin/env bash

# New command to rename a branch

set -- "$*"


"$DIR"/lib/rename-branch.sh "$3" "$4"
exit 1
