#!/usr/bin/env bash

# Rename parameter is more easy then --amend

set -- "$*"

if [[ $3 == "rename" ]]; then
    git commit --amend
    exit 1
fi

if [[ $3 == "remove" ]]; then
    git reset --soft HEAD~"$4"
    exit 1
fi
