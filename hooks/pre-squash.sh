#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

# New command to rename a branch

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 3 parameters (script, command, count)
if [[ ${#parameters[@]} -ge 3 ]] && [[ "${parameters[2]}" != "" ]]; then
    git reset --soft HEAD~"${parameters[2]}" && git commit;
    exit 1;
fi
