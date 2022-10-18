#!/usr/bin/env bash

# FZF picker to rebase interactive

# Requirements
#  - fzf
set -- "$*"

if [[ $3 == "-i" && $4 == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source "$DIR"/../lib/forgit.sh
    forgit::rebase
    exit 1
fi
