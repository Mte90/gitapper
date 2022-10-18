#!/usr/bin/env bash

# FZF picker to diff interactive

# Requirements
#  - fzf
set -- "$*"
if [[ $3 == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source "$DIR"/../lib/forgit.sh
    forgit::diff
    exit 1
fi
