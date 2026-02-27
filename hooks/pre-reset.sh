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
# If parameters[2] is not empty, it means there are arguments (e.g., --hard, HEAD)
# In that case, exit 0 allows git reset to proceed with the provided arguments
if [[ ${#parameters[@]} -lt 3 ]] || [[ "${parameters[2]}" != "" ]]; then
    # Command has arguments, let git handle it
    exit 0
fi

# No parameters passed, use forgit for interactive reset
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"$DIR"/../lib/forgit.sh reset_head
exit 1
