#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

# FZF picker to reset interactive

# Requirements
#  - fzf

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 3 parameters (script, command, args)
# Exit early if not enough parameters
if [[ ${#parameters[@]} -lt 3 ]] || [[ "${parameters[2]}" != "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/../lib/forgit.sh reset HEAD
    exit 1
fi
