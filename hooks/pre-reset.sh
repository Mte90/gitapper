#!/usr/bin/env bash

# FZF picker to reset interactive

# Requirements
#  - fzf
set -- "$*"

if [[ $3 == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source "$DIR"/../lib/forgit.sh
    forgit::reset::head
    exit 1
fi
