#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

# FZF picker to rebase interactive

# Requirements
#  - fzf

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 4 parameters (script, command, -i, and optional args)
if [[ ${#parameters[@]} -ge 4 ]] && [[ "${parameters[2]}" == "-i" ]] && [[ "${parameters[3]}" == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/../lib/forgit.sh rebase
    exit 1
fi
