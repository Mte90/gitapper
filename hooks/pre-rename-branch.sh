#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

# New command to rename a branch

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 4 parameters (script, command, old_branch, new_branch)
if [[ ${#parameters[@]} -ge 4 ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/../lib/rename-branch.sh "${parameters[2]}" "${parameters[3]}"
fi
