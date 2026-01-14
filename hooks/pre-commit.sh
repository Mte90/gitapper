#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

# Rename parameter is more easy then --amend

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 3 parameters (script, command, action)
if [[ ${#parameters[@]} -ge 3 ]]; then
    if [[ ${parameters[2]} == "rename" ]]; then
        git commit --amend
    fi

    if [[ ${parameters[2]} == "remove" ]] && [[ ${#parameters[@]} -ge 4 ]]; then
        git reset --soft HEAD~"${parameters[3]}"
        exit 1
    fi
fi
