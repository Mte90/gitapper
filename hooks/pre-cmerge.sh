#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

# New command to squash N commits into one with the oldest commit message
# Usage: git cmerge N

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 3 parameters (script, command, count)
if [[ ${#parameters[@]} -ge 3 ]] && [[ "${parameters[2]}" != "" ]]; then
    count="${parameters[2]}"
    
    # Verify it's a number
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo "Error: '$count' is not a valid number"
        exit 1
    fi
    
    # Get the oldest commit message from the last N commits
    oldest_msg=$(git log --format=%B --reverse HEAD~"$count"..HEAD | head -1)
    
    git reset --soft HEAD~"$count"
    echo "$oldest_msg" > /tmp/cmerge_msg.txt
    git commit -e -F /tmp/cmerge_msg.txt
    rm -f /tmp/cmerge_msg.txt
    
    exit 1
fi