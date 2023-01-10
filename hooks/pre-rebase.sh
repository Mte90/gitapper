#!/usr/bin/env bash

# FZF picker to rebase interactive

# Requirements
#  - fzf
set -- "$*"
parameters=($1)

if [[ ${parameters[2]} == "-i" && ${parameters[3]} == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/../lib/forgit.sh rebase
    exit 1
fi
