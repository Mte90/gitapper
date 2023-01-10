#!/usr/bin/env bash

# FZF picker to clean interactive

# Requirements
#  - fzf
set -- "$*"
parameters=($1)

if [[ ${parameters[2]} == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/../lib/forgit.sh clean
    exit 1
fi
