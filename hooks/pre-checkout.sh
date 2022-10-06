#!/usr/bin/env bash

# Download a GitHub pull request and create a new branch with that

# Requirements
#  - jq
set -- "$*"

repo=$3
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
    exit 1
fi

# FZF picker to checkout on branch

# Requirements
#  - fzf
set -- "$*"

parameter=$3
if [[ $parameter == "" ]]; then
    forgit::checkout::branch
    exit 1
fi
