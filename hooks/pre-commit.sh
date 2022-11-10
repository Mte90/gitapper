#!/usr/bin/env bash

# Rename parameter is more easy then --amend

set -- "$*"
parameters=($1)

if [[ ${parameters[2]} == "rename" ]]; then
    git commit --amend
    exit 1
fi

if [[ ${parameters[2]} == "remove" ]]; then
    git reset --soft HEAD~"${parameters[3]}"
    exit 1
fi
