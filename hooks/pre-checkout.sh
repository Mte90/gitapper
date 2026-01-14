#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

# Download a GitHub pull request and create a new branch with that

# Requirements
#  - jq

set -- "$*"
read -ra parameters <<< "$1"

# First section: Handle GitHub PR checkout
if [[ ${#parameters[@]} -ge 3 ]]; then
    repo=${parameters[2]}
    if [[ $repo == *"https://github.com/"* ]]; then
        repo_full="${repo#https\:\/\/github\.com\/}"
        repo="${repo_full%\/pull\/[[:digit:]]*}"
        id="${repo_full/$repo/}"
        id="${id/\/pull\//}"

        payload=$(curl -s https://api.github.com/repos/"$repo"/pulls/"$id" || exit 1)
        to_branch=$(/bin/echo "$payload" | jq -r '.head.ref')

        echo " - Download pull request $id from $repo"

        $1 fetch origin pull/"$id"/head:"$to_branch"
        $1 checkout "$to_branch"
        payload=$(curl -s https://api.github.com/repos/"$repo"/pulls/"$id" || exit 1)
        to_branch=$(/bin/echo "$payload" | jq -r '.head.ref')

        echo " - Download pull request $id from $repo"

        $1 fetch origin pull/"$id"/head:"$to_branch"
        $1 checkout "$to_branch"
    fi
fi

# FZF picker to checkout on branch

# Requirements
#  - fzf

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 3 parameters (script, command, args)
if [[ ${#parameters[@]} -ge 3 ]] && [[ "${parameters[2]}" == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/../lib/forgit.sh checkout_branch
    exit 1
fi
